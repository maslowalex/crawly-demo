defmodule AutoriaCars.Spider do
  use Crawly.Spider

  alias Crawly.Utils

  @images_directory Application.get_env(:crawly, :image_folder)

  @impl Crawly.Spider
  def base_url(), do: "https://auto.ria.com"

  @impl Crawly.Spider
  def init(), do: [start_urls: start_urls()]

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    hrefs = 
      document
      |> Floki.find(".content-bar a.m-link-ticket")
      |> Enum.map(fn link -> Floki.attribute(link, "href") end)

    requests = hrefs |> List.flatten |> Utils.build_absolute_urls(base_url()) |> Utils.requests_from_urls()

    %Crawly.ParsedItem{
      items: [build_item(document, response.request_url)],
      requests: requests
    }
  end

  defp build_item(document, url) do
    maker = document |> Floki.find("h1") |> Floki.find("span") |> List.first() |> Floki.text()
    model = document |> Floki.find("h1") |> Floki.find("span") |> List.last() |> Floki.text()
    title = document |> Floki.find(".heading") |> Floki.text()
    price = document |> Floki.find("#showLeftBarView .price strong") |> Floki.text()
    mileage = document |> Floki.find(".base-information") |> Floki.text() |> String.trim()
    item_id = extract_id(url)
    image_path = store_img_and_get_path(document, item_id)

    %{
      title: title,
      maker: maker,
      model: model,
      price: price,
      mileage: mileage,
      url: url,
      item_id: item_id,
      image_path: image_path
    }
  end

  defp extract_id(url) do
    case Regex.run(~r"\d{7,9}", url) do
      nil -> nil
      [id] -> id
    end
  end

  defp store_img_and_get_path(_document, _item_id = nil), do: nil
  defp store_img_and_get_path(document, item_id) do
    case document |> Floki.find(".photo-620x465") |> List.first |> Floki.find("source") |> Floki.attribute("srcset") |> List.first() do
      nil -> nil
      link -> link |> get_image(item_id)
    end
  end

  defp get_image(link, item_id) do
    with %HTTPoison.Response{body: body} <- HTTPoison.get!(link),
          :ok <- File.write!("#{@images_directory}/#{item_id}.webp", body) do
            Path.absname("./#{@images_directory}/#{item_id}.webp")
        else
          _ -> nil
    end
  end

  defp start_urls() do
    Enum.map(1..3000, fn page_number -> 
      "https://auto.ria.com/uk/search/?indexName=auto,order_auto,newauto_search&year[0].gte=2010&year[0].lte=2020&categories.main.id=1&country.import.usa.not=-1&price.currency=1&abroad.not=0&custom.not=1&page=#{page_number}&size=20"
    end)
  end
end
