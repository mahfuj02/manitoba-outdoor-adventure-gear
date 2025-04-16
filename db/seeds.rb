# Seed Canadian provinces with tax rates
puts "Creating provinces with tax rates..."
provinces_data = [
  { name: 'Alberta', code: 'AB', gst: 5, pst: 0, hst: 0 },
  { name: 'British Columbia', code: 'BC', gst: 5, pst: 7, hst: 0 },
  { name: 'Manitoba', code: 'MB', gst: 5, pst: 7, hst: 0 },
  { name: 'New Brunswick', code: 'NB', gst: 0, pst: 0, hst: 15 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst: 0, pst: 0, hst: 15 },
  { name: 'Northwest Territories', code: 'NT', gst: 5, pst: 0, hst: 0 },
  { name: 'Nova Scotia', code: 'NS', gst: 0, pst: 0, hst: 15 },
  { name: 'Nunavut', code: 'NU', gst: 5, pst: 0, hst: 0 },
  { name: 'Ontario', code: 'ON', gst: 0, pst: 0, hst: 13 },
  { name: 'Prince Edward Island', code: 'PE', gst: 0, pst: 0, hst: 15 },
  { name: 'Quebec', code: 'QC', gst: 5, pst: 9.975, hst: 0 },
  { name: 'Saskatchewan', code: 'SK', gst: 5, pst: 6, hst: 0 },
  { name: 'Yukon', code: 'YT', gst: 5, pst: 0, hst: 0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(code: province_data[:code]) do |province|
    province.name = province_data[:name]
    province.gst = province_data[:gst]
    province.pst = province_data[:pst]
    province.hst = province_data[:hst]
  end
end
puts "Created #{Province.count} provinces"