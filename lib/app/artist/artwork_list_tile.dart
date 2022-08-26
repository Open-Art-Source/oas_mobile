import 'package:flutter/material.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/services/ifps_service.dart';

class ArtworkListTile extends StatelessWidget with ImagesFromIfps {
  final Artwork artwork;
  final VoidCallback? onTap;

  ArtworkListTile({Key? key, required this.artwork, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: false,
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 55,
          minHeight: 55,
          maxWidth: 55,
          maxHeight: 55,
        ),
        child: primaryThumb,
      ),
      title: Text(artwork.title),
      subtitle: Text(artwork.medium),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
