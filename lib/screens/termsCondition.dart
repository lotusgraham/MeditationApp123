import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed suscipit nec neque et efficitur. Vivamus dapibus semper accumsan. Curabitur euismod risus diam, ut dapibus dolor pellentesque sit amet. Donec eleifend iaculis neque, ut maximus nulla laoreet et. Pellentesque aliquam egestas dictum. Nullam feugiat justo ac mi viverra, non finibus lacus lacinia. Aenean faucibus ex vitae ultricies imperdiet. Sed in vulputate elit. Duis sagittis dui sed viverra commodo.

Sed eleifend dui eget leo sodales, vitae rhoncus ex ultrices. Proin orci odio, blandit nec accumsan eu, dapibus id ipsum. Cras ornare id lacus sagittis tempus. Integer nec pulvinar risus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris eu sapien posuere, gravida urna nec, porttitor tellus. Duis quis aliquet turpis.

Suspendisse quis nibh et augue vestibulum malesuada in vitae lacus. Nam turpis nunc, rhoncus vitae justo mollis, posuere laoreet tortor. Morbi cursus in enim laoreet accumsan. Ut lectus leo, pharetra sit amet mollis ut, semper et lorem. Curabitur condimentum nec dolor ut malesuada. Nunc vel ligula et nulla molestie dictum ac id odio. Suspendisse viverra consequat elementum. Etiam euismod magna arcu, in finibus tellus convallis eu. Pellentesque pharetra eu enim tristique scelerisque. Pellentesque porta elit eu tellus accumsan posuere. Mauris at mi quis nisl eleifend consectetur quis nec metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In sed euismod neque, eu blandit velit.

Mauris mi leo, pretium vitae dapibus et, elementum et nisl. Nullam semper enim in sollicitudin placerat. Suspendisse potenti. Duis pulvinar sodales ullamcorper. Integer aliquet diam ac posuere mollis. Integer blandit orci ac ex auctor sagittis. Donec suscipit dui non efficitur accumsan.

Suspendisse venenatis ligula ex, ut sodales massa scelerisque pretium. Cras vel facilisis sapien. Nulla tortor velit, elementum vitae sodales ut, pharetra vel ex. In vel aliquam velit. Maecenas euismod elementum metus, id ullamcorper massa suscipit vitae. Proin consequat vitae nunc vel blandit. Nunc sed purus erat. Proin id ligula velit. Maecenas luctus sed diam ut ultrices. Nunc turpis tellus, mattis id pretium sed, elementum quis purus. Nam vel ante iaculis, tincidunt magna nec, finibus sapien. Curabitur tincidunt velit sit amet nisl semper, et fermentum libero aliquet.''',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 17.0,
              height: 1.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
