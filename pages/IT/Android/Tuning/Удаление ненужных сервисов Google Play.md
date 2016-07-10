# Удаление ненужных сервисов Google Play.
> В последнее время все приложения стали больше занимать памяти и на нашем довольно таки старом устройстве все начинает подтормаживать и зависать. Больше всего памяти у меня занимали "Службы Google Play". Порыскав по форумам, поиспытывав лично у меня сложилась таблица Service,Receiver,Activity, которые можно поотключать для Сервисов Google Play и Google Service Framework. После произведенных манипуляций телефон стал реально шустрее бегать, появилось больше свободной памяти, батарея стала держать больше. Я не играю в игры и особенно в онлайн-игры, не пользуюсь устройствами ANT+, смарт-часами, фитнес браслетами. Но звоню, пишу смс, пользую WhatsApp и Bluetooth-гарнитуру. Все это продолжает работать без сбоев вот уже две недели.

![Удаление ненужных сервисов Google Play](/images/Linux/Android/Tuning/disable_servise_GP_1.jpg 'Удаление ненужных сервисов Google Play')

![Удаление ненужных сервисов Google Play](/images/Linux/Android/Tuning/disable_servise_GP_2.jpg 'Удаление ненужных сервисов Google Play')

![Удаление ненужных сервисов Google Play](/images/Linux/Android/Tuning/disable_servise_GP_3.jpg 'Удаление ненужных сервисов Google Play')

**Все что вы делаете - делается под вашу ответственность, я не гарантирую работоспособности данных изменений. Пользуйтесь CWM и TitaniumBackup - ОБЯЗАТЕЛЬНО ДЕЛАЙТЕ КОПИИ перед любыми изменениями**

Для отключения использовались программы 3C Toolbox (все отключения делал в ней) и MyAndroidTools (контроль отключенного - более удобный и читаемый список)

Для контроля загруженности аппарата - PowerTutor и WakelockDetector

Если вы не знаете эти программы - лучше не беритесь.

**Только для телефонов с ROOT**

## Отключения в Сервисах Google Play.
### Service
- ActivityRecognitionService
- AdRequestBrokerService
- AdvertisingIdService
- AnalyticsIntentService
- BluetoothClientService
- BluetoothServerService
- BrokeredFitnessService
- CacheUpdateService
- CastDeviceScannerIntentService
- CastMediaRouteProviderService
- CastMirroringIntentService
- CastMirroringService
- CastOperationService
- CastRemoteDisplayProviderService
- CastRemoteMirroringService
- CastService
- CastSocketMultiplexerLifeCycleService
- CheckinService
- CollectSensorService
- ConfigFetchService
- CoreAnalyticsIntentService
- CrashReportIntentService
- DataRemovalService
- DbCleanupService
- DebugIntentService
- EventLogService
- FitnessSyncAdapterService
- FusedLocationService
- FusedProviderService
- GamesAndroidService
- GamesIntentService
- GamesSignInIntentService
- GamesSignInService
- GamesSyncServiceMain
- GamesSyncServiceNotification
- GamesUploadService
- GcmSchedulerWakeupService
- GeocodeService
- GeofenceProviderService
- GservicesValueBrokerService
- LocationWearableListenerService
- NegotiationService
- NetworkConnectionService
- NlpLocationReceiverService
- ProxyGTalkService
- RoomAndroidService
- SnapshotEventService
- SyncService
- SystemUpdateService
- WatchdogService
- WearableControlService
- WearableService
- WearableSyncService

### Receiver
- AccountsChangedReceiver (их 2)
- AutoStarterReceiver
- CheckinServiceActiveReceiver
- CheckinServiceReceiver
- CheckinServiceSecretCodeReceiver
- CheckinServiceTriggerReceiver
- CollectSensorReceiver
- ConnectivityReceiver
- DoritosReceiver
- EventLogServiceReceiver
- FitnessInitReceiver
- GamesSystemBroadcastReceiver
- GcmBroadcastReceiver
- GcmReceiver
- InternalIntentReceiver
- PowerConnectedReceiver
- SystemEventReceiver
- SystemUpdateServiceActiveReceiver
- SystemUpdateServiceReceiver
- SystemUpdateServiceSecretCodeReceiver
- WearableSyncServiceReceiver

### Activity
- AdsSettingsActivity
- ClientAchievementListActivity
- ClientLeaderboardListActivity
- ClientLeaderboardScoreActivity
- ClientMultiplayerInboxListActivity
- ClientPlayerSearchActivity
- ClientPublicInvitationListActivity
- ClientPublicRequestListActivity
- ClientQuestActivity
- ClientQuestListActivity
- ClientRequestInboxListActivity
- ClientSettingsActivity
- ClientSnapshotListActivity
- FitnessSettingsActivity
- GamesSettingsActivity
- GamesSettingsDebugActivity
- HeadlessInboxActivity
- HeadlessLevelUpTrampolineActivity
- HeadlessLevelUpUpsellActivity
- HeadlessMultiplayerListActivity
- HeadlessPublicInvitationListActivity
- HeadlessPublicRequestListActivity
- HeadlessRequestListActivity
- ParcelTestCompatActivity
- RealTimeWaitingRoomActivity
- RestrictedAchievementDescriptionActivity
- RestrictedParticiplantListActivity
- SecuredCreditCardOcrActivity
- SelectOpponentsActivity
- SendRequestActivity
- SignInActivity
- SystemUpdateActivity

## Отключения в Google Service Framework
### Service
- CheckinService
- EventLogService
- StatsUploadService
- SubscribedFeedsIntentService
- SubscribedFeedsSyncAdapterService
- SystemUpdateService

### Receiver
- ChekinServiceReceiver
- CheckinServiceSecretCodeReceiver
- CheckinServiceTriggerReceiver
- EventLogServiceReceiver
- MigrateToAccountManagerBroadCastReceiver
- SystemUpdateServiceReceiver
- SystemUpdateServiceSecretCodeReceiver

### Activity
- SystemUpdateActivity

## Как отключать Сервисы Google Play программой 3C Toolbox.
По списку работать проще через MyAndroidTools - я названия с него списывал. В 3С они будут немного отличаться (более полные)

**Отключение через 3C Toolbox:**

1. Заходим в менеджер приложений
2. Внизу средняя кнопка - ставим все или системные - чтобы открылся список системных.
3. Ищем Сервисы Google Play. Тапаем на них.
4. Они выделяются и внизу становится активной кнопка открыть. Тапаем на нее.
5. Открывается подменю. В нем первая кнопка "подробнее"
6. Тапаем. Открывается инфа о процессе.
7. Ну и тут свайпом вправо переходим на Активность (Activity), Провайдеры(Providers), Приемники(Receivers) , Сервисы (Services)
8. И там уже галочками отключаем ненужное.

