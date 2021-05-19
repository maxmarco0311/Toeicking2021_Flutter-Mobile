import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// 自訂user類別
class User extends Equatable {
  // 來自Firebase user物件的id
  final String id;
  final String username;
  final String email;
  // profile照片的下載字串
  final String profileImageUrl;
  final int followers;
  final int following;
  final String bio;

  const User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.profileImageUrl,
    @required this.followers,
    @required this.following,
    @required this.bio,
  });
  // 空的User物件
  static const empty = User(
    id: '',
    username: '',
    email: '',
    profileImageUrl: '',
    followers: 0,
    following: 0,
    bio: '',
  );

  @override
  List<Object> get props => [
        id,
        username,
        email,
        profileImageUrl,
        followers,
        following,
        bio,
      ];
  // 在不同事件中，用來更新物件最新值的方法-->更新狀態
  User copyWith({
    String id,
    String username,
    String email,
    String profileImageUrl,
    int followers,
    int following,
    String bio,
  }) {
    return User(
      // 若傳入參數為空，就用原本物件屬性的值
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }

  // 回傳"非"此類別型別的物件(--> 使用"自訂方法"
  // 將自訂User物件轉成Firestore Document物件存進DB：Map<String, dynamic>
  // 欄位名稱為String型別，欄位值為dynamic型別
  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'bio': bio,
    };
  }

  // 回傳此類別型別的物件-->使用"工廠多載"(也可用一般方法)
  // 將查出的Firestore Document物件(DocumentSnapshot)轉為自訂User物件
  factory User.fromDocument(DocumentSnapshot doc) {
    // 如果找不到(doc == null)就回傳null
    if (doc == null) return null;
    // doc.data()才能取出一筆Document資料，回傳Map<String, dynamic>
    final data = doc.data();
    // 裝回此類型物件(自訂user物件)
    return User(
      // doc.id取得Document的id
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      // Firestore的數值型別為number和double，轉成Dart要用toInt()
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
    );
  }
}