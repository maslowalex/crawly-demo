use Mix.Config

config :crawly,
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:maker, :mileage, :model, :price, :title, :url, :item_id, :image_path]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :item_id},
    {Crawly.Pipelines.CSVEncoder, fields: [:maker, :model, :mileage, :price, :url, :image_path]},
    {Crawly.Pipelines.WriteToFile, extension: "csv", folder: "output"}
  ]

# config :nadia,
#   token: "Yourtoken"
