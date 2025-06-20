import 'package:bottom_picker/bottom_picker.dart';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/features/auth/signup/presentation/bloc/register_cubit.dart';
import 'package:convo/features/auth/signup/presentation/bloc/register_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBarthDatePicker extends StatelessWidget {
  final bool showError;

  const CustomBarthDatePicker({super.key, this.showError = false});

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);
    final String dateNow = DateTime.now().toString().substring(0, 10);

    return BlocBuilder<RegisterCubit, RegisterStates>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            BottomPicker.date(
              pickerTitle: Text(
                'Set your Birthday',
                style: quicksand20(color: AppColors.primary950),
              ),
              dateOrder: DatePickerDateOrder.ymd,
              initialDateTime: DateTime.now(),
              maxDateTime: DateTime.now(),
              minDateTime: DateTime(1950),
              pickerTextStyle: TextStyle(
                color: AppColors.primary800,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              onSubmit: (selectedDate) {
                cubit.updateBirthDate(selectedDate);
              },
              buttonStyle: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: AppColors.primary800,
              ),
            ).show(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              children: [
                Text(
                  'Birthday',
                  style: quicksand18(
                    color: showError ? Colors.red : AppColors.primary950,
                  ).copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Text(
                  cubit.isBirthdaySelected
                      ? cubit.selectedBirthday.toString().substring(0, 10)
                      : dateNow,
                  style: quicksand18(
                    color: showError ? Colors.red : AppColors.primary700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}