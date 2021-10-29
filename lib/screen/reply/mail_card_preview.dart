import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/layout/adaptive.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:lcss_mobile_app/screen/reply/colors.dart';
import 'package:lcss_mobile_app/screen/reply/mail_view_page.dart';
import 'package:lcss_mobile_app/screen/reply/model/email_model.dart';
import 'package:lcss_mobile_app/screen/reply/model/email_store.dart';
import 'package:lcss_mobile_app/screen/reply/profile_avatar.dart';
import 'package:provider/provider.dart';

class MailPreviewCard extends StatelessWidget {
  const MailPreviewCard({
    Key key,
    @required this.id,
    @required this.onDelete,
    @required this.onStar,
    @required this.isStarred,
    @required this.onStarredMailbox,
    @required this.notification,
  })  : assert(id != null),
        super(key: key);

  final int id;
  final VoidCallback onDelete;
  final VoidCallback onStar;
  final bool isStarred;
  final bool onStarredMailbox;
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO(shihaohong): State restoration of mail view page is
    // blocked because OpenContainer does not support restorablePush.
    // See https://github.com/flutter/flutter/issues/69924.
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return MailViewPage(id: id, notification: notification);
      },
      openColor: theme.cardColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: theme.cardColor,
      closedBuilder: (context, openContainer) {
        final isDesktop = isDisplayDesktop(context);
        final colorScheme = theme.colorScheme;
        final mailPreview = _MailPreview(
          id: id,
          notification: notification,
          onTap: openContainer,
          onStar: onStar,
          onDelete: onDelete,
        );

        if (isDesktop) {
          return mailPreview;
        } else {
          return Dismissible(
            key: ObjectKey(notification),
            dismissThresholds: const {
              DismissDirection.startToEnd: 0.8,
              DismissDirection.endToStart: 0.4,
            },
            onDismissed: (direction) {
              switch (direction) {
                case DismissDirection.endToStart:
                  if (onStarredMailbox) {
                    onStar();
                  }
                  break;
                case DismissDirection.startToEnd:
                  onDelete();
                  break;
                default:
              }
            },
            background: _DismissibleContainer(
              icon: 'twotone_delete',
              backgroundColor: colorScheme.primary,
              iconColor: ReplyColors.blue50,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsetsDirectional.only(start: 20),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                if (onStarredMailbox) {
                  return true;
                }
                onStar();
                return false;
              } else {
                return true;
              }
            },
            secondaryBackground: _DismissibleContainer(
              icon: 'twotone_star',
              backgroundColor: isStarred
                  ? colorScheme.secondary
                  : theme.scaffoldBackgroundColor,
              iconColor: isStarred
                  ? colorScheme.onSecondary
                  : colorScheme.onBackground,
              alignment: Alignment.centerRight,
              padding: const EdgeInsetsDirectional.only(end: 20),
            ),
            child: mailPreview,
          );
        }
      },
    );
  }
}

class _DismissibleContainer extends StatelessWidget {
  const _DismissibleContainer({
    @required this.icon,
    @required this.backgroundColor,
    @required this.iconColor,
    @required this.alignment,
    @required this.padding,
  })  : assert(icon != null),
        assert(backgroundColor != null),
        assert(iconColor != null),
        assert(alignment != null),
        assert(padding != null);

  final String icon;
  final Color backgroundColor;
  final Color iconColor;
  final Alignment alignment;
  final EdgeInsetsDirectional padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: alignment,
      curve: standardEasing,
      color: backgroundColor,
      duration: kThemeAnimationDuration,
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: ImageIcon(
          AssetImage(
            'reply/icons/$icon.png',
            package: 'flutter_gallery_assets',
          ),
          size: 36,
          color: iconColor,
        ),
      ),
    );
  }
}

class _MailPreview extends StatelessWidget {
  const _MailPreview({
    @required this.id,
    @required this.notification,
    @required this.onTap,
    this.onStar,
    this.onDelete,
  })  : assert(id != null),
        assert(notification != null),
        assert(onTap != null);

  final int id;
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onStar;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var emailStore = Provider.of<EmailStore>(
      context,
      listen: false,
    );

    return InkWell(
      onTap: () {
        Provider.of<EmailStore>(
          context,
          listen: false,
        ).selectedEmailId = id;
        onTap();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${notification.senderUsername} - ${notification.creatingDate}',
                              style: textTheme.caption,
                            ),
                            const SizedBox(height: 4),
                            Text(notification.title,
                                style: textTheme.headline5),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      _MailPreviewActionBar(
                        avatar: 'assets/images/cnpr_logo2.png',
                        isStarred: emailStore
                            .isEmailStarred(notification.notificationId),
                        onStar: onStar,
                        onDelete: onDelete,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 20,
                    ),
                    child: Text(
                      notification.body,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textTheme.bodyText2,
                    ),
                  ),
                  // if (email.containsPictures) ...[
                  //   Flexible(
                  //     fit: FlexFit.loose,
                  //     child: Column(
                  //       children: const [
                  //         SizedBox(height: 20),
                  //         _PicturePreview(),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PicturePreview extends StatelessWidget {
  const _PicturePreview();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: Image.asset(
              'reply/attachments/paris_${index + 1}.jpg',
              gaplessPlayback: true,
              package: 'flutter_gallery_assets',
            ),
          );
        },
      ),
    );
  }
}

class _MailPreviewActionBar extends StatelessWidget {
  const _MailPreviewActionBar({
    @required this.avatar,
    this.isStarred,
    this.onStar,
    this.onDelete,
  }) : assert(avatar != null);

  final String avatar;
  final bool isStarred;
  final VoidCallback onStar;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? ReplyColors.white50 : ReplyColors.blue600;
    final isDesktop = isDisplayDesktop(context);
    final starredIconColor =
        isStarred ? Theme.of(context).colorScheme.secondary : color;

    return Row(
      children: [
        if (isDesktop) ...[
          IconButton(
            icon: ImageIcon(
              const AssetImage(
                'assets/icons/twotone_star.png',
              ),
              color: starredIconColor,
            ),
            onPressed: onStar,
          ),
          IconButton(
            icon: ImageIcon(
              const AssetImage(
                'assets/icons/twotone_delete.png',
              ),
              color: color,
            ),
            onPressed: onDelete,
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: color,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
        ProfileAvatar(avatar: avatar),
      ],
    );
  }
}
