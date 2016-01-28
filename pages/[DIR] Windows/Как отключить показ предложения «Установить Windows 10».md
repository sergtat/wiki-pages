# Как отключить показ предложения «Установить Windows 10».
![Как отключить показ предложения «Установить Windows 10»](/images/Windows/nowin10.png 'Как отключить показ предложения «Установить Windows 10»')

1. Деинсталлировать обновление KB3035583. Для этого достаточно вызвать такую командную строку с правами администратора:  
  
	```
wusa.exe //uninstall //kb:3035583
	```
2. Зайти в RegEdit, открыть ключ «HKLM\SOFTWARE\Policies\Microsoft\Windows\GWX» и изменить значение переменной «DisableGwx» на 1
3. Открыть ключ «HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate» и изменить значение переменной «DisableOSUpgrade» на 1
4. Завершить процесс «gwx.exe». Это так же можно сделать, вызвав командную строку:  
  
	```
	Taskkill.exe //IM gwx.exe //F
	```
.
