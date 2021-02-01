use Mix.Config

config :crawly,
  closespider_timeout: 100,
  concurrent_requests_per_domain: 8,
  closespider_itemcount: 100,
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:maker, :mileage, :model, :price, :title, :url, :item_id]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :item_id},
    AutoriaCars.Pipelines.SendTelegramMessage,
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "jl", folder: "output"}
  ]

config :nadia,
  token: "yourtoken"
