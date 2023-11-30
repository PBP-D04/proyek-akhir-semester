import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
class MyDrawer extends ConsumerStatefulWidget{

  final Function(String identifier) callBack;

  const MyDrawer({super.key, required this.callBack});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyDrawerState();
  }
}

class _MyDrawerState extends ConsumerState<MyDrawer>{
  ResponsiveValue responsiveValue = ResponsiveValue();
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider);
    responsiveValue.setResponsive(context);
    // TODO: implement build
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: userData != null? responsiveValue.appBarHeight : 100,
            color: Colors.indigoAccent.shade700,
            padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: userData != null?Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: responsiveValue.profilePictureSize * 0.8,
                      backgroundImage: NetworkImage(
                        userData!.profilePicture != null && !userData!.profilePicture!.isEmpty
                            ? userData!.profilePicture!
                            : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      userData.fullname!,
                      softWrap: false, // Tidak akan ada pemisahan baris
                      overflow: TextOverflow.ellipsis, // Teks yang tidak muat akan ditampilkan dengan ellipsis (...)
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveValue.titleFontSize, // Ukuran nama lengkap
                        fontWeight: FontWeight.bold, // Gaya teks nama lengkap
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@'+userData.username!,
                      style: TextStyle(
                          fontSize: responsiveValue.subtitleFontSize, // Ukuran username
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade200// Gaya teks username
                      ),
                      softWrap: false, // Tidak akan ada pemisahan baris
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                        padding: EdgeInsets.all(12), // Padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                        ),
                      ),
                      child: Text(
                        'Your Profile',
                        style: TextStyle(
                          fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                          color: Colors.white, // Warna teks
                          fontWeight: FontWeight.bold, // Gaya teks
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                        padding: EdgeInsets.all(12), // Padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                        ),
                      ),
                      child: Text(
                        'Your Books',
                        style: TextStyle(
                          fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                          color: Colors.white, // Warna teks
                          fontWeight: FontWeight.bold, // Gaya teks
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                        padding: EdgeInsets.all(12), // Padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: responsiveValue.titleFontSize, // Ukuran teks
                          color: Colors.white, // Warna teks
                          fontWeight: FontWeight.bold, // Gaya teks
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                        padding: EdgeInsets.all(12), // Padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: responsiveValue.titleFontSize, // Ukuran teks
                          color: Colors.white, // Warna teks
                          fontWeight: FontWeight.bold, // Gaya teks
                        ),
                      ),
                    ),
                  ],

                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home), // Ikon untuk halaman utama
            title: Text('Home', style: TextStyle(fontSize: responsiveValue.subtitleFontSize),),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              widget.callBack('HOME');
              // Tindakan ketika ListTile Halaman Utama diklik
              // Misalnya: Navigasi ke halaman utama
            },
          ),
          // ListTile untuk menambah item
          ListTile(
            leading: Icon(Icons.menu_book_rounded), // Ikon untuk menambah item
            title: Text('Books', style: TextStyle(fontSize: responsiveValue.subtitleFontSize)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              widget.callBack('BOOKS');
              // Tindakan ketika ListTile Tambah Item diklik
              // Misalnya: Navigasi ke halaman tambah item
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded), // Ikon untuk menambah item
            title: Text('Dashboard', style: TextStyle(fontSize: responsiveValue.subtitleFontSize)),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              widget.callBack('DASHBOARD');
              // Tindakan ketika ListTile Tambah Item diklik
              // Misalnya: Navigasi ke halaman tambah item
            },
          ),
          Spacer(),
          Container(
            child: Row(
              children: [
                Flexible(child: ListTile(
                  leading: Icon(Icons.settings), // Ikon untuk halaman utama
                  title: Text('Setting', style: TextStyle(fontSize: responsiveValue.subtitleFontSize),),
                  onTap: () {
                    // Tindakan ketika ListTile Halaman Utama diklik
                    // Misalnya: Navigasi ke halaman utama
                  },
                ),),
                userData != null ? Flexible(child: ListTile(
                  leading: Icon(Icons.logout), // Ikon untuk halaman utama
                  title: Text('Logout', style: TextStyle(fontSize: responsiveValue.subtitleFontSize),),
                  onTap: () {
                    ref.read(authProvider.notifier).clearUserData();
                  },
                ),) : Container()
              ],
            ),
          ),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}