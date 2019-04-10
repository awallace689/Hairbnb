class Barber
{
  String name;
  String phone;
  String hours;
  String location;
  String facebook;
  String instagram;
  String website;

  Barber( String name,
        String phone,
        String hours,
        String location,
        String facebook,
        String instagram,
        String website)
  {
    this.name = name;
    this.phone = phone;
    this.hours = hours;
    this.location = location;
    this.facebook = facebook;
    this.instagram = instagram;
    this.website = website;
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'phone': phone,
        'hours': hours,
        'location': location,
        'facebook': facebook,
        'instagram': instagram,
        'website': website,
      };

  factory Barber.fromJson(Map<String, dynamic> parsedJson){
    return Barber(
        parsedJson['name'],
        parsedJson['phone'],
        parsedJson['hours'],
        parsedJson['location'],
        parsedJson['facebook'],
        parsedJson['instagram'],
        parsedJson['website']
    );
  }
}