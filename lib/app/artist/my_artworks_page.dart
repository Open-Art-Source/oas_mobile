import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oas_mobile/app/artist/edit_artwork_page.dart';
import 'package:oas_mobile/app/artist/artwork_list_tile.dart';
import 'package:oas_mobile/app/artist/empty_content.dart';
import 'package:oas_mobile/app/sign_in/logout.dart';
import 'package:provider/provider.dart';
import 'package:oas_mobile/app/mobx_stores/my_artworks_store.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';


class MyArtworksPage extends StatelessWidget with Logout {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      appBar: OasAppBar(title: 'My Works', logoutFunc: () => confirmSignOut(context),),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditArtworkPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    MyArtworksStore store =
        Provider.of<MyArtworksStore>(context, listen: false);
    return Observer(builder: (_) {
      if (store.myArtworks.isEmpty) {
        return EmptyContent();
      }
      return ListView.separated(
          shrinkWrap: true,
          itemCount: store.myArtworks.length + 2,
          separatorBuilder: (context, index) => Divider(height: 0.7),
          itemBuilder: (context, index) {
            if (index == 0 || index == store.myArtworks.length + 1) {
              return Container();
            }
            return ArtworkListTile(
                artwork: store.myArtworks[index - 1],
                onTap: () => EditArtworkPage.show(context,
                    artwork: store.myArtworks[index - 1]));
          });
    });
  }


}
