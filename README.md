## Group 12 - Project: Music App 
## Members:
Đinh Xuân Quyền 22010342

Phan Văn Tình 22010122

Tạ Văn Thanh 22010161

## Introduction
Ứng dụng nghe nhạc số cơ bản, người dùng sẽ có các chức năng nghe và phát nhạt, tạo danh sách các bài hát  
![image](https://github.com/user-attachments/assets/43f5369b-6e99-40cd-906c-150525612188)

# Structural Diagram
## UML diagram 
![image](https://github.com/user-attachments/assets/e0fc8ef5-aadf-42d5-80b5-761dd3621475)
## Sequence diagram
Chức năng tạo danh sách bài hát

![image](https://github.com/user-attachments/assets/0c4677fa-786f-4ff5-a097-576af32c291b)

Chức năng xóa bài hát khỏi danh sách 

![image](https://github.com/user-attachments/assets/c2fff65b-c83a-4296-8155-0816f8612886)

Chức năng phát và dừng nhạc

![image](https://github.com/user-attachments/assets/4743ffc2-70cc-4391-b5e9-0d8e642d5535)

Chức năng tua bài hát

![image](https://github.com/user-attachments/assets/76ec0265-ceb4-49a1-b016-9dd28dff1cba)

Chức năng chọn bài kế tiếp

![image](https://github.com/user-attachments/assets/104a8218-5232-4f83-99a9-b29604e035f7)

Chức năng lặp lại bài hát

![image](https://github.com/user-attachments/assets/5a342b1d-e844-4179-bad6-8bb510122946)





## Activity Diagram
Chức năng tạo danh sách bài hát

![image](https://github.com/user-attachments/assets/ba98bf7a-adfb-492f-9aef-7f11577a8ff4)

Chức năng thêm bài hát vào danh sách phát 
![image](https://github.com/user-attachments/assets/1291ce7d-f30d-4e7a-af22-c475224e5655)

Chức năng xóa bài hát khỏi danh sách 

![image](https://github.com/user-attachments/assets/a52c359c-d3df-4e0e-b048-e4f23b023760)

Chức năng phát nhạc
![image](https://github.com/user-attachments/assets/f313e090-bf59-4580-a060-c23addc0a2f0)

Chức năng dừng nhạc

![image](https://github.com/user-attachments/assets/fc005c1a-89cb-418f-83cd-03f19b3f4b44)

Chức năng tua bài hát

![image](https://github.com/user-attachments/assets/defa131c-452d-4f4c-9f09-226521747415)


Chức năng chọn bài kế tiếp

![image](https://github.com/user-attachments/assets/c8c1eb4a-8c92-4670-b821-1856499ce9ab)


Chức năng lặp lại bài hát

![image](https://github.com/user-attachments/assets/dffd51a8-b67c-4590-945e-cfe90a25139f)






## Class Diagram

Class User {
  int UserId;
  
  String name;
  
  String email;
},


Class Playlist{
  List<Track> tracks = []; 
  
  int PlayId;
  
  String Namesong;
  
  String Author;
  
  String description;
  
  DateTime createdAt;
  
  DateTime updatedAt;      
  
  bool repeat = false;   
  
  bool isPlaying = false;         
}


class Song {
  String title;         
  
  String artist;   
  
  int duration;    
  
  String genre;    
  
  int releaseYear;   
  
  String album;        
  
  String audioFormat;  
  
  }
