import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_rent/blank.dart';
import 'package:smart_rent/core/model/room/room.dart';
import 'package:smart_rent/core/values/app_colors.dart';
import 'package:smart_rent/core/widget/date_input_form_field.dart';
import 'package:smart_rent/core/widget/text_form_field_input.dart';
import 'package:smart_rent/modules/handle_return_room_tenant/controllers/send_request_return_room_controller.dart';
import 'package:smart_rent/modules/root_view/views/root_screen.dart';

class SendRequestReturnRoom extends StatelessWidget {
  SendRequestReturnRoom({
    super.key,
    required this.room,
    this.result,
  });
  Map<String, dynamic>? result;
  final Room room;
  late double deviceHeight;
  late double deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    final sendRequestController = Get.put(
      SendRequestReturnRoomController(
        room: room,
        result: result,
      ),
    );
    final oCcy = NumberFormat("#,##0", "vi_VN");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary98,
        title: const Text(
          'Gửi yếu cầu trả phòng',
          style: TextStyle(
            color: primary40,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(deviceWidth * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Thông tin xác nhận',
                        style: TextStyle(
                          color: primary40,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                      const Text(
                        'Tên phòng',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(
                        room.title,
                        style: const TextStyle(
                          color: secondary40,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      const Text(
                        'Địa chỉ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(
                        room.location,
                        style: const TextStyle(
                          color: secondary40,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      const Text(
                        'Giá thuê',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(
                        '${oCcy.format(room.price)}đ',
                        style: const TextStyle(
                          color: secondary40,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      const Text(
                        'Bắt đầu thuê',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: secondary40,
                          ),
                          SizedBox(
                            width: deviceWidth * 0.03,
                          ),
                          Text(
                            DateFormat('HH:mm dd/MM/yyyy').format(
                              DateTime.parse(room.dateTime),
                            ),
                            style: const TextStyle(
                              color: secondary40,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              const Text(
                'Yêu cầu trả phòng',
                style: TextStyle(
                  color: primary40,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              const Text(
                'Ngày trả phòng',
                style: TextStyle(
                  color: secondary40,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => SwitchListTile(
                  value: sendRequestController.isReturnNow.value,
                  activeColor: Colors.white,
                  activeTrackColor: primary60,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.only(
                    left: 0,
                  ),
                  onChanged: (value) {
                    sendRequestController.isReturnNow.value = value;
                  },
                  title: const Text(
                    'Muốn trả phòng ngay',
                    style: TextStyle(
                      color: primary40,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Form(
                key: sendRequestController.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Obx(
                      () => !sendRequestController.isReturnNow.value
                          ? DateInputField(
                              firstDate: 1900,
                              lastDate: DateTime.now().year + 1,
                              borderRadius: BorderRadius.circular(8),
                              borderWidth: 2,
                              borderColor: primary60,
                              textEditingController:
                                  sendRequestController.textFormReturnDate,
                              labelText: 'Ngày trả phòng',
                              hintText: DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now())
                                  .toString(),
                              icon: Icons.timelapse_outlined,
                              onDateSelected: (DateTime selectedDate) {
                                sendRequestController.textFormReturnDate.text =
                                    DateFormat('dd/MM/yyyy')
                                        .format(selectedDate)
                                        .toString();
                              },
                              onValidate: (value) {
                                if (!sendRequestController.isDate(value!)) {
                                  return 'Vui lòng nhập ngày trả phòng';
                                }
                                return null;
                              },
                            )
                          : const SizedBox(),
                    ),
                    const Text(
                      'Lí do',
                      style: TextStyle(
                        color: secondary40,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    TextFormFieldInput(
                      textEditingController:
                          sendRequestController.textFormReason,
                      labelText: 'Lí do',
                      hintText: 'Lí do (*)',
                      textInputType: TextInputType.text,
                      borderRadius: BorderRadius.circular(8),
                      borderWidth: 2,
                      borderColor: primary60,
                      icon: const Icon(
                        Icons.text_decrease,
                      ),
                      onSaved: (newValue) {},
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập lí do';
                        }
                        return null;
                      },
                      autoCorrect: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              const Text(
                'Bằng việc gửi yêu cầu trả phòng, bạn cam kết trả phòng đúng thời gian quy định ',
                style: TextStyle(
                  color: secondary40,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  textBaseline: TextBaseline.alphabetic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Obx(
                () => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Tôi cam kết thực hiện đúng như hợp đồng',
                    style: TextStyle(
                      color: secondary20,
                      fontSize: 14,
                    ),
                  ),
                  value: sendRequestController.isAgreePolicy.value,
                  onChanged: (value) {
                    sendRequestController.isAgreePolicy.value = value!;
                  },
                  activeColor: primary40,
                  contentPadding: const EdgeInsets.only(
                    left: 0,
                  ),
                ),
              ),
              Obx(
                () => sendRequestController.isAgreePolicy.value
                    ? Align(
                        alignment: Alignment.center,
                        child: OutlinedButton(
                            onPressed: () async {
                              sendRequestController.sendRequest(room);
                            },
                            child: const Text(
                              'Gửi yêu cầu',
                              style: TextStyle(
                                color: primary40,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
