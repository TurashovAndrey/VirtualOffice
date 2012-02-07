# coding: utf-8
module Helper
  require 'envolve_chat'

  def self.get_chat_script(user)

    if (user!=nil)
      @firstname = user.first_name=="" ? user.email: user.first_name
      @envolve_html_code = EnvolveChat::ChatRenderer.get_html("50879-2vO9DDq6kmqbiIViHl2rntDi9mFADrIY",
      {
        :first_name => @firstname,
        :last_name => user.last_name,
        :is_admin => false,
        :groups => [{:id => user.company.url_base, :name => user.company.name},{:id => "Default", :name => "Default chat"}],
        :strings => "TurnOff:'Закрыть программу', TurnOnTooltip:'Открыть программу', Sound:'Включить/выключить звук',"+
                    "SettingsLink:'Открыть панель администратора', LogOutTitleText:'Выйти из чата', LoggingOut:'Выход из чата',"+
                    "PeopleListHeaderText:'Кто сейчас в чате', ThisIsYou:'Ваш профайл', NoOneIsHere:'В чате никого нет', YourNameIs:'Ваш ник',"+
                    "PleaseLoginBeginning:'Пожалуйста,', PleaseLoginEnd:'чтобы изменить свой ник', PeopleListTitleSingular:'пользователь в чате',"+
                    "PeopleListTitlePlural:'пользователей в чате', DragAndDropHelperText:'добавляем пользователя', Other:'человек еще',"+
                    "PeopleArePlural:'находятся в чате', PersonIsSingular:'находится в чате', JustBrowsing:'в качестве наблюдателя',"+
                    "GuestsPlural:'в качестве гостей', GuestSingular:'в качестве гостя',TypeAStatusMessageHere:'Напишите свой статус',"+
                    "Minimize:'Свернуть',PopOut:'Открыть этот чат в новом окне',PopIn:'Вернуться к проежнему окну',"+
                    "PeopleHere:'человек в чате',OnlyParticipant:'Больше никого в чате',ClearChat:'Очистить чат',ChatCleared:'Чат был очищен',"+
                    "WaitingForUserToAccept:'Ожидание принятия приглашения',YouInvited:'Вы пригласили',ToChat:'в новый чат',"+
                    "InviteOthers:'Вы можете пригласить других пользователей',UserInvited:'Пользователь был приглашен',InvitedPrompt:'Приглашен',"+
                    "InvitationAccepted:'Приглашение принято',InvitationRejected:'Приглашение отклонено',IsNow:'изменил свой ник на',"+
                    "Sending:'Посылка сообщения',PersonIsTyping:'Печатает',SomeoneIsTyping:'Пользователь печатает',"+
                    "SlowDown:'Деятельность приостановлена',PressEnterToSend:'Нажмите Enter, чтобы отправить',SaveChatDropDown:'Сохранить чат',"+
                    "SaveChatConfirmation:'Чат сохранен',SaveChatWarning:'Пользователь пытается сохранить чат',ShareDirectLink:'Поделиться',"+
                    "ShareTwitterBody:'Поделиться через Твиттер',ShareFacebookBody:'Поделиться через Фейсбук',BootUser:'Добавить в чат',"+
                    "BootUserTooltip:'Добавить этого пользователя в чат',BlockUser:'Блокировать',BlockUserTooltip:'Блокировать этого пользователя',"+
                    "BlockConfirmation:'Пользователь блокирован',BanUser:'Забанить пользователя',BanUserTooltip:'Забанить этого пользователя',"+
                    "BanConfirmation:'Пользователь забанен',BanReason:'Причина бана',AdminCloseConfirmation:'Чат закрыт админом',"+
                    "JustMeButton:'Только мне',EveryoneButton:'Всем',NewMessage:'Получено новое сообщение',PublicChatIntro1:'Это публичный чат',"+
                    "PublicChatInviteIntructions:'Добавьте новых пользователей, перетащив их сюда',PrivateChat:'Это приватный чат',"+
                    "PrivateChatIntrol:'Ожидается принятие приглашения',IsSpeaking:'указал своим родным языком',TranslationEnable:'Включить перевод',"+
                    "TranslationDisable:'Отключить перевод',Translating:'Выполняется перевод',TranslatedTooltip:'Переведено',NewChatButton:'Новый чат',"+
                    "NewChatTooltip:'Создать новый публичный чат',NewChatTitlePrompt:'Напишите название своего чата',NewChatShareWith:'Кто приглашен',"+
                    "Everyone:'Все',NoOne:'Никто',StartChatButton:'Начать чат',NewChatNoTitle:'Нужно ввести имя!',NewChatBadTitle:'Недопустимое имя',"+
                    "MoreChats:'Прочие чаты',MoreChatsTooltip:'Открыть список прочих чатов',OldChats:'Старые чаты',CurrentChats:'Текущие чаты',"+
                    "DirectLinkFollow:'Присоединиться к публичному чату',PrivateChatInvite:'Приглашение в приватный чат',PublicChatInvite:'Приглашение в публичный чат',"+
                    "ChatButton:'Начать чат',AcceptButton:'Принять приглашение',IgnoreButton:'Игнорировать приглашение',CancelButton:'Отмена',"+
                    "CloseButton:'Закрыть',SignInButton:'Войти как...',BlockButton:'Блокировать',BanButton:'Забанить',ClickSignInButton:'Войдите, чтобы отправить сообщение',"+
                    "SetName:'Введите свое полное имя',FirstNameError:'Необходимо ввести имя',SignIn:'выполните вход',Back:'Назад',FirstName:'Имя',"+
                    "LastName:'Фамилия',RegisterBeforeSaving:'Нужно зарегистрироваться, чтобы сохранить чат',ChatFull:'Чат переполнен',"+
                    "ChatFullTooltip:'Новые пользователи не могут присоединиться, так как чат переполнен',WrongDomain:'Запрещенный домен',"+
                    "WrongDomainTooltip:'Попытка доступа с запрещенного домена',MoreInfoLink:'Подробнее об ошибке',BannedFromChat:'Вы забанены в этом чате',"+
                    "LoginRequiredToCreateChat:'Нужно выполнить вход, чтобы создать чат',LoginRequiredToChat:'Нужно выполнить вход, чтобы продолжать',NoSSL:'SSL отключен',"+
                    "NoSSLTooltip:'Ошибка доступа: отключен SSL'"

        # :strings => "TurnOff : 'Выключить',TurnOnTooltip:'Включить',Sound:'Звук',LogOutTitleText:'Выйти',LoggingOut:'Выйти из чата'"
      })
    else
      @envolve_html_code = EnvolveChat::ChatRenderer.get_html("50879-2vO9DDq6kmqbiIViHl2rntDi9mFADrIY",
      {
        :is_admin => false,
        :strings => "TurnOff:'Закрыть программу', TurnOnTooltip:'Открыть программу', Sound:'Включить/выключить звук',"+
                    "SettingsLink:'Открыть панель администратора', LogOutTitleText:'Выйти из чата', LoggingOut:'Выход из чата',"+
                    "PeopleListHeaderText:'Кто сейчас в чате', ThisIsYou:'Ваш профайл', NoOneIsHere:'В чате никого нет', YourNameIs:'Ваш ник',"+
                    "PleaseLoginBeginning:'Пожалуйста,', PleaseLoginEnd:'чтобы изменить свой ник', PeopleListTitleSingular:'пользователь в чате',"+
                    "PeopleListTitlePlural:'пользователей в чате', DragAndDropHelperText:'добавляем пользователя', Other:'человек еще',"+
                    "PeopleArePlural:'находятся в чате', PersonIsSingular:'находится в чате', JustBrowsing:'в качестве наблюдателя',"+
                    "GuestsPlural:'в качестве гостей', GuestSingular:'в качестве гостя',TypeAStatusMessageHere:'Напишите свой статус',"+
                    "Minimize:'Свернуть',PopOut:'Открыть этот чат в новом окне',PopIn:'Вернуться к проежнему окну',"+
                    "PeopleHere:'человек в чате',OnlyParticipant:'Больше никого в чате',ClearChat:'Очистить чат',ChatCleared:'Чат был очищен',"+
                    "WaitingForUserToAccept:'Ожидание принятия приглашения',YouInvited:'Вы пригласили',ToChat:'в новый чат',"+
                    "InviteOthers:'Вы можете пригласить других пользователей',UserInvited:'Пользователь был приглашен',InvitedPrompt:'Приглашен',"+
                    "InvitationAccepted:'Приглашение принято',InvitationRejected:'Приглашение отклонено',IsNow:'изменил свой ник на',"+
                    "Sending:'Посылка сообщения',PersonIsTyping:'Печатает',SomeoneIsTyping:'Пользователь печатает',"+
                    "SlowDown:'Деятельность приостановлена',PressEnterToSend:'Нажмите Enter, чтобы отправить',SaveChatDropDown:'Сохранить чат',"+
                    "SaveChatConfirmation:'Чат сохранен',SaveChatWarning:'Пользователь пытается сохранить чат',ShareDirectLink:'Поделиться',"+
                    "ShareTwitterBody:'Поделиться через Твиттер',ShareFacebookBody:'Поделиться через Фейсбук',BootUser:'Добавить в чат',"+
                    "BootUserTooltip:'Добавить этого пользователя в чат',BlockUser:'Блокировать',BlockUserTooltip:'Блокировать этого пользователя',"+
                    "BlockConfirmation:'Пользователь блокирован',BanUser:'Забанить пользователя',BanUserTooltip:'Забанить этого пользователя',"+
                    "BanConfirmation:'Пользователь забанен',BanReason:'Причина бана',AdminCloseConfirmation:'Чат закрыт админом',"+
                    "JustMeButton:'Только мне',EveryoneButton:'Всем',NewMessage:'Получено новое сообщение',PublicChatIntro1:'Это публичный чат',"+
                    "PublicChatInviteIntructions:'Добавьте новых пользователей, перетащив их сюда',PrivateChat:'Это приватный чат',"+
                    "PrivateChatIntrol:'Ожидается принятие приглашения',IsSpeaking:'указал своим родным языком',TranslationEnable:'Включить перевод',"+
                    "TranslationDisable:'Отключить перевод',Translating:'Выполняется перевод',TranslatedTooltip:'Переведено',NewChatButton:'Новый чат',"+
                    "NewChatTooltip:'Создать новый публичный чат',NewChatTitlePrompt:'Напишите название своего чата',NewChatShareWith:'Кто приглашен',"+
                    "Everyone:'Все',NoOne:'Никто',StartChatButton:'Начать чат',NewChatNoTitle:'Нужно ввести имя!',NewChatBadTitle:'Недопустимое имя',"+
                    "MoreChats:'Прочие чаты',MoreChatsTooltip:'Открыть список прочих чатов',OldChats:'Старые чаты',CurrentChats:'Текущие чаты',"+
                    "DirectLinkFollow:'Присоединиться к публичному чату',PrivateChatInvite:'Приглашение в приватный чат',PublicChatInvite:'Приглашение в публичный чат',"+
                    "ChatButton:'Начать чат',AcceptButton:'Принять приглашение',IgnoreButton:'Игнорировать приглашение',CancelButton:'Отмена',"+
                    "CloseButton:'Закрыть',SignInButton:'Войти как...',BlockButton:'Блокировать',BanButton:'Забанить',ClickSignInButton:'Войдите, чтобы отправить сообщение',"+
                    "SetName:'Введите свое полное имя',FirstNameError:'Необходимо ввести имя',SignIn:'выполните вход',Back:'Назад',FirstName:'Имя',"+
                    "LastName:'Фамилия',RegisterBeforeSaving:'Нужно зарегистрироваться, чтобы сохранить чат',ChatFull:'Чат переполнен',"+
                    "ChatFullTooltip:'Новые пользователи не могут присоединиться, так как чат переполнен',WrongDomain:'Запрещенный домен',"+
                    "WrongDomainTooltip:'Попытка доступа с запрещенного домена',MoreInfoLink:'Подробнее об ошибке',BannedFromChat:'Вы забанены в этом чате',"+
                    "LoginRequiredToCreateChat:'Нужно выполнить вход, чтобы создать чат',LoginRequiredToChat:'Нужно выполнить вход, чтобы продолжать',NoSSL:'SSL отключен',"+
                    "NoSSLTooltip:'Ошибка доступа: отключен SSL'"

        #:strings => "TurnOff : 'Выключить', TurnOnTooltip:'Включить', Sound:'Звук', LogOutTitleText:'Выйти', LoggingOut:'Выйти из чата'"
      })
    end

    @envolve_html_code
  end
end