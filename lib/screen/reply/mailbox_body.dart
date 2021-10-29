import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/layout/adaptive.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:lcss_mobile_app/screen/reply/mail_card_preview.dart';
import 'package:lcss_mobile_app/screen/reply/model/email_model.dart';
import 'package:lcss_mobile_app/screen/reply/model/email_store.dart';
import 'package:provider/provider.dart';

class MailboxBody extends StatelessWidget {
  const MailboxBody({Key key, @required this.listNotification})
      : super(key: key);

  final List<NotificationModel> listNotification;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final isTablet = isDisplaySmallDesktop(context);
    final startPadding = isTablet
        ? 60.0
        : isDesktop
            ? 120.0
            : 4.0;
    final endPadding = isTablet
        ? 30.0
        : isDesktop
            ? 60.0
            : 4.0;

    return Consumer<EmailStore>(
      builder: (context, model, child) {
        final destination = model.selectedMailboxPage;
        final destinationString = destination
            .toString()
            .substring(destination.toString().indexOf('.') + 1);
        List<Email> emails;

        switch (destination) {
          case MailboxPageType.inbox:
            {
              emails = model.inboxEmails;
              break;
            }
          case MailboxPageType.sent:
            {
              emails = model.outboxEmails;
              break;
            }
          case MailboxPageType.starred:
            {
              emails = model.starredEmails;
              break;
            }
          case MailboxPageType.trash:
            {
              emails = model.trashEmails;
              break;
            }
          case MailboxPageType.spam:
            {
              emails = model.spamEmails;
              break;
            }
          case MailboxPageType.drafts:
            {
              emails = model.draftEmails;
              break;
            }
        }

        return SafeArea(
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: emails.isEmpty
                    ? Center(child: Text('Hiện tại không có thông báo nào'))
                    : ListView.separated(
                        itemCount: listNotification.length,
                        padding: EdgeInsetsDirectional.only(
                          start: startPadding,
                          end: endPadding,
                          top: isDesktop ? 28 : 0,
                          bottom: kToolbarHeight,
                        ),
                        primary: false,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          // var email = emails[index];
                          NotificationModel notification =
                              listNotification[index];
                          return MailPreviewCard(
                            id: notification.notificationId,
                            isStarred: model
                                .isEmailStarred(notification.notificationId),
                            onDelete: () =>
                                model.deleteEmail(notification.notificationId),
                            onStar: () =>
                                model.starEmail(notification.notificationId),
                            notification: notification,
                            onStarredMailbox: model.selectedMailboxPage ==
                                MailboxPageType.starred,
                          );
                        },
                      ),
              ),
              if (isDesktop) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 14),
                  child: Row(
                    children: [
                      IconButton(
                        key: const ValueKey('ReplySearch'),
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Provider.of<EmailStore>(
                            context,
                            listen: false,
                          ).onSearchPage = true;
                        },
                      ),
                      SizedBox(width: isTablet ? 30 : 60),
                    ],
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
