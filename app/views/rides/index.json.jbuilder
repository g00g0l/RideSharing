json.array!(@rides) do |ride|
  json.extract! ride, :id, :from, :to, :date, :time
  json.url ride_url(ride, format: :json)
end
