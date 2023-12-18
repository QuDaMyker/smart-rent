import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_rent/core/values/app_colors.dart';
import 'package:smart_rent/core/widget/room_item.dart';
import 'package:smart_rent/modules/home/controllers/home_list_room_controller.dart';

class HomeListRoomWidget extends StatefulWidget {
  const HomeListRoomWidget({super.key});

  @override
  State<HomeListRoomWidget> createState() => _HomeListRoomWidgetState();
}

class _HomeListRoomWidgetState extends State<HomeListRoomWidget> {
  HomeListRoomController listRoomController = Get.put(HomeListRoomController());

  @override
  void initState() {
    super.initState();
    listRoomController.getListRoom(false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Phòng nổi bật',
                style: TextStyle(
                  fontSize: 20,
                  color: secondary20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(
            () => listRoomController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primary95,
                      backgroundColor: Colors.white,
                    ),
                  )
                : listRoomController.listRoom.value.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/empty.json',
                              repeat: true,
                              reverse: true,
                              height: 300,
                              width: double.infinity,
                            ),
                            const Text(
                              'Hệ thống đang cập nhật phòng',
                              style: TextStyle(
                                color: secondary20,
                                fontSize: 18,
                                fontWeight: FontWeight.w200,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          return listRoomController.getListRoom(false);
                        },
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.66,
                            crossAxisSpacing: 5,
                            // mainAxisSpacing: 20,
                          ),
                          itemCount:
                              listRoomController.listRoom.value.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index <
                                listRoomController.listRoom.value.length) {
                              return RoomItem(
                                isHandleRequestReturnRoom: false,
                                isReturnRent: false,
                                isRented: false,
                                room: listRoomController.listRoom.value[index],
                                isLiked: listRoomController
                                    .listRoom.value[index].listLikes
                                    .contains(
                                  FirebaseAuth.instance.currentUser!.uid,
                                ),
                              );
                            } else {
                              return Obx(
                                () => listRoomController.isLoadMore.value
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: primary95,
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              listRoomController
                                                  .getListRoom(true);
                                            },
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(
                                                const BorderSide(
                                                  color: primary40,
                                                ),
                                              ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Xem thêm',
                                              style: TextStyle(
                                                color: primary40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            }
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
