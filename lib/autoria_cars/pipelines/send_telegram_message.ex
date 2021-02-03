defmodule AutoriaCars.Pipelines.SendTelegramMessage do
  @behaviour Crawly.Pipeline

  require Logger
  @recepient_tg_id 12345

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    case do_send_telegram_msg(item) do
      {:ok, _} -> {item, state}
      {:error, _} -> {false, state}
    end
  end

  defp do_send_telegram_msg(item) do
    Nadia.send_message(
      @recepient_tg_id,
      msg_text(item),
      disable_notification: true
    )
  end

  defp msg_text(item) do
    """
      #{item.maker} #{item.model}
      #{item.mileage}
      #{item.price}
      #{item.url}
    """
  end
end
