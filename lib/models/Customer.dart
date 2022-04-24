class Customer {
  String? id;
  String? email;
  String? password;
  String? username;
  String? name;
  String? address;
  String? phone;
  String? state;
  int? role;
  String? updatedAt;
  String? createdAt;

  Customer(
      {this.id,
      this.email,
      this.password,
      this.username,
      this.name,
      this.address,
      this.phone,
      this.state,
      this.role,
      this.updatedAt,
      this.createdAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    username = json['username'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    state = json['state'];
    role = json['role'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['username'] = this.username;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['role'] = this.role;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
