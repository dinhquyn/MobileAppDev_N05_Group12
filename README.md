# MobileAppDev_N05_Group12
# Ảnh màn Hình Home 

![image](https://github.com/user-attachments/assets/d9258553-e88c-4bde-8b59-d28678ecad2a)


# Ảnh màn Hình User

![image](https://github.com/user-attachments/assets/cd7b5269-0c1d-4f2e-9149-b50aa344dc4f)


# Class User
class User {

  final String username;
  
  final String password;
  
  final String role;
  

  User({
  
    required this.username,
    
    required this.password,
    
    required this.role,
    
  });
}

# Object của class User 
import 'user.dart';

final List<User> users = [

  User(username: 'Đinh Xuân Quyền', password: '123456@Abc', role: 'Admin'),
  
  User(username: 'Phan Văn Tình', password: '123456@Abc', role: 'User'),
  
  User(username: 'Hoàng Trọng Đức', password: '123456@Abc', role: 'User'),
  
  User(username: 'Nguyễn Đức Hà', password: '123456@Abc', role: 'User'),
  
  User(username: 'Nguyễn Văn Nam', password: '123456@Abc', role: 'User'),
  
];

# Hiển thị danh sách 5 user theo dạng GridView.
import 'user_data.dart';

 Widget _buildUserGrid() {
 
    return GridView.builder(
    
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      
        crossAxisCount: 5,
        
        crossAxisSpacing: 8,
        
        mainAxisSpacing: 8,
        
        childAspectRatio: 0.6,
        
      ),
      
      itemCount: users.length,
      
      itemBuilder: (context, index) {
      
        return Card(
        
          elevation: 5,
          
          margin: EdgeInsets.all(10),
          
          child: Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
            
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
            
              Icon(Icons.person, size: 50, color: Colors.blue),
              
              SizedBox(height: 10),
              
              Text(
              
                users[index].username,
                
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                
              ),
              
              Text(
              
                'Role: ${users[index].role}',
                
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                
              ),
              
            ],
            
          ),
          
        );
        
      },
      
    );
    
  }
  
}


# Ảnh chụp 5 bản ghi người dùng 
![image](https://github.com/user-attachments/assets/88e9226b-affd-4a49-b711-c66dd685e319)
