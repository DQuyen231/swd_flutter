import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateLaundryStatus extends StatefulWidget {
  final String orderId;

  UpdateLaundryStatus({required this.orderId});

  @override
  _UpdateLaundryStatusState createState() => _UpdateLaundryStatusState();
}

class _UpdateLaundryStatusState extends State<UpdateLaundryStatus> {
  int selectedStatus = 0; // Default status as a number
  int laundryStatus = -1;

  final statusMap = {
    0: 'Pending',
    1: 'Washing',
    2: 'Finished',
  };
  @override
  void initState() {
    super.initState();

    fetchLaundryStatus(widget.orderId);
  }

  Future<void> fetchLaundryStatus(String orderId) async {
    final apiUrl =
        'https://13.212.24.193/api/v1/orders/$orderId/order-histories';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // API call was successful, process the response here

        final data = json.decode(response.body);
        print(data);

        laundryStatus = data['data']['items'][0]['laundryStatus'];
        print(laundryStatus);

        setState(() {});
      } else {
        print(
            'Failed to fetch delivery status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching delivery status: $e');
    }
  }

  Future<void> updateLaundryStatus(String orderId, int status) async {
    final apiUrl =
        'https://13.212.24.193/api/v1/orders/$orderId/order-history?LaundryStatus=$status';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Laundry status updated successfully.');
      } else {
        print(
            'Failed to update laundry status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while updating laundry status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String statusText = statusMap[laundryStatus] ?? 'Unknown';

    return AlertDialog(
      title: Text(
          "LaundryStatus Status: ${statusMap[laundryStatus]}"), // Display the delivery status as text
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child:
                    Text('Change status to: ', style: TextStyle(fontSize: 14)),
              ),
              DropdownButton<int>(
                value: selectedStatus,
                items: statusMap.keys.map((int status) {
                  return DropdownMenuItem<int>(
                    value: status,
                    child: Text(statusMap[status] ?? 'Unknown'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedStatus = newValue ?? 0;
                  });
                },
              ),
              SizedBox(width: 8.0),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Update'),
          onPressed: () {
            // Add your code to update the delivery status with the selected status.
            updateLaundryStatus(widget.orderId, selectedStatus);
            Navigator.of(context).pop(); // Close the dialog.
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog.
          },
        ),
      ],
    );
  }
}
