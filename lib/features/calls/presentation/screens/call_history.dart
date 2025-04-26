import 'package:convo/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';

class CallHistory extends StatelessWidget {
  final List<Map<String, dynamic>> calls = [

    {
      'name': 'Mohamed Farahat',
      'time': 'Today, 11:03 AM',
      'avatar': 'assets/images/mo.png',
      'isMissed': false,
    },
    {
      'name': 'Mohamed Farahat',
      'time': 'Today, 10:30 AM',
      'avatar': 'assets/imagesmo.png',
      'isMissed': false,
    },
    {
      'name': 'Omar Ahmed',
      'time': 'Yesterday, 09:30 AM',
      'avatar': 'assets/images/omar.png',
      'isMissed': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text("Calls", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset('assets/images/search.png', width: 45, height: 45),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 300),
                  child: Text(
                    "Recent",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: calls.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(calls[index]['avatar']),
                      ),
                      title: Text(
                        calls[index]['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(calls[index]['time']),
                      trailing: Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/Calls.png',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            'assets/images/Video.png',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey.shade300,
                      thickness: 0.5,
                      indent: 70,
                      endIndent: 20,
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
