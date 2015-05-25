User.create(email: 'admin@houztrendz.com', password: 'test1234', role: 'admin')

Definition.create! do |d|
  d.name = 'Test'
  d.class_name = 'TestDefinition'
  d.active = true
  d.vgl_header = <<-HEADER
font_family "http://vejeo.s3.amazonaws.com/vidgenie/fonts/lato/Lato-Bold.ttf"
colors blue: "0,112,238", white: "255,255,255", gray: "136, 136, 136"
  HEADER

  d.vgl_content = <<-CONTENT
b.stack(background: colors[:white]) do

  b.overlay("0","0","100","100") do

    b.movie("https://video-snippets.s3.amazonaws.com/encoded/7800/49514dee-9957-448f-a90c-1a8a45644bde_720.mp4", 0, 0, "100", "100").duration(10)

    b.counter(10, "37", "33","20","20", size: 60, color: "82,82,82", align: "left", depth: -50, delay: 3, duration: 3, font: "Museo_Slab_900.otf")
      .animate("37","33", scale: {value: 0..0, origin: "left"}, duration:2, depth: -50)
      .animate("37","33", scale: {value: 0..1, origin: "left"}, duration:1.25, depth: -50)
      .animate("70","70", scale: {value: 1..1, origin: "left"}, depth: -50, duration:3.15, easing: "ease_out_sine")
      .animate("70","70", scale: {value: 1..1, origin: "left"}, depth: -50, duration:6)
  end
  	.animate("0", "0", duration: 3, rotate_y: 0..0, scale: {value: 1..1, origin: "center"})
    .animate("4", "0", duration: 9, rotate_y: 0..10, rotate_x: 0..5, scale: {value: 1..0.9, origin: "center"})
  	.duration(12)

end
  CONTENT
end

ftb_location = FindTheBestLocation.create! do |f|
  f.ftb_id = 18118
  f.county = ' Kent County'
  f.sale_price_intro = 'The median sale price in'
  f.sale_price_verb = 'has decreased'
  f.sale_price_change = '10.50%'
  f.sale_price_end = 'over the past year, which suggests the market has been cooling off'
  f.expected_intro = 'Additionally, home values in the area are expected to decrease'
  f.expected_change = '0.60%'
  f.expected_months = 'over the next 12 months'
  f.list_price_intro = 'The median listing price of for-sale homes is now'
  f.list_price_change = '4.60%'
  f.list_price_end = 'higher than it was a year ago'
  f.market_text = 'While the typical home is on the market for about 4 fewer weeks before being sold'
end

Video.create! do |v|
  v.videoable = ftb_location
  v.filename = "#{SecureRandom.uuid}.mp4"
  v.duration = 120
end
