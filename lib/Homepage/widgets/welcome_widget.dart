import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';

import '../../models/user.dart';
import '../../util/responsive_config.dart';

class WelcomeWidget extends StatelessWidget {
  final User? user; // Variabel untuk menyimpan data pengguna
  final VoidCallback onClose;
  ResponsiveValue responsiveValue = ResponsiveValue();
  WelcomeWidget({required this.user, required this.onClose});

  @override
  Widget build(BuildContext context) {
    responsiveValue.setResponsive(context);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            if (user != null)
              CircleAvatar(
                radius: getScreenSize(context) == ScreenSize.small? 40 : 50,
                backgroundImage: user!.profilePicture!= null
                    ? NetworkImage(user!.profilePicture!)
                    : NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'), // Gambar profil atau default jika tidak tersedia
              ),
            if(user != null)SizedBox(height: 20),
            if (user != null)
              Text(
                'Hai, ${user!.fullname ?? 'Tamu'}, Selamat Datang', textAlign: TextAlign.center,
                style: TextStyle(fontSize: responsiveValue.titleFontSize, color: Colors.white,  ),
              ),
            if (user == null) // Jika user adalah null (pengguna adalah tamu)
              Column(
                children: [
                  Text(
                    'Untuk menikmati pengalaman yang lebih baik, silahkan login atau register',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveValue.titleFontSize, color: Colors.white, ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('Login', style:  TextStyle(fontSize: responsiveValue.subtitleFontSize, color: Colors.white, ),),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Tambahkan logika untuk tombol register di sini
                        },
                        child: Text('Register',style: TextStyle(fontSize: responsiveValue.subtitleFontSize, color: Colors.white, ),),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
