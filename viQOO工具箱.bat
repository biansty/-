::����һ�����ű�ʾ��,�밴�մ�ʾ���е�����������ɽű�������.

::����׼��,����Ķ�
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.�Ҳ���bin & goto FATAL)

::���ؿ�ܻ������ú�ָ��������,����Ķ�
if exist conf\framwork.bat (call conf\framwork) else (ECHO.�Ҳ���conf\framwork.bat & goto FATAL)
if exist framwork.bat (call framwork theme %framwork_theme%) else (ECHO.�Ҳ���framwork.bat & goto FATAL)
COLOR %c_i%

::�Զ��崰�ڴ�С,���԰�����Ҫ�Ķ�
TITLE viQOO������������...
mode con cols=71

::���ͻ�ȡ����ԱȨ��,�粻��Ҫ����ȥ��
if not exist tool\Windows\gap.exe ECHO.�Ҳ���gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start gap.exe %0 && EXIT || EXIT

::����׼���ͼ��,����Ķ�
call framwork startpre

::�����Զ�������.�����Զ��������ļ�Ӧ�ڴ�ʱ����
call conf\user.bat

::�������.���������д��Ľű�
TITLE viQOO������ V%prog_ver% ����:�ᰲ@ĳ�� [�������]
CLS
goto MENU



:MENU
call log viQOO������.bat-menu I �������˵�
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.                        viQOO������ - ���˵�
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_w%}        �����俪Դ���, ��ֹ����, ��ֹδ����ɵĶ���, ���, ����{%c_i%}{\n}
ECHO.           viQOO�°汾��BFF���ǿ������: gitee.com/mouzei/bff
if not "%product%"=="" ECHO. & ECHO. [%model%]
ECHO.
ECHO. 0.�������ǵ�һ����
ECHO.
ECHO. 1.����BL��   2.Root��ȡ��Root   3.ˢ�������Recovery
ECHO.
ECHO. 4.ˢ���Զ������
ECHO.
ECHO. A.ѡ���ͺ�   B.������   C.��������   D.������־
ECHO.
call choice common [0][1][2][3][4][A][B][C]
if "%choice%"=="0" goto ALETTER
if "%choice%"=="1" goto UNLOCKBL
if "%choice%"=="2" goto ROOT
if "%choice%"=="3" goto REC
if "%choice%"=="4" goto CUSTOMFLASH
if "%choice%"=="A" goto SELDEV
if "%choice%"=="B" goto UPDATE
if "%choice%"=="C" goto THEME
if "%choice%"=="D" goto LOG




:CUSTOMFLASH
SETLOCAL
set logger=viQOO������.bat-customflash
call log %logger% I ���빦��:ˢ���Զ������
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.ˢ���Զ������
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
:CUSTOMFLASH-1
ECHOC {%c_h%}������Ҫˢ��ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto CUSTOMFLASH-1
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��Ҫˢ���img�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
ECHOC {%c_h%}�뽫�豸����Fastbootģʽ...{%c_i%}{\n}& call chkdev fastboot rechk 1
ECHO.���ڽ�%sel__file_path%ˢ��%parname%...& call write fastboot %parname% %sel__file_path%
ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul
call log %logger% I ��ɹ���:ˢ���Զ������
ENDLOCAL
goto MENU


:REC
SETLOCAL
set logger=viQOO������.bat-rec
call log %logger% I ���빦��:ˢ�������Recovery
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.ˢ�������Recovery
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_w%}ע��: ѡ�������ͺŻ�׿�汾���ܵ����豸�޷�����Recovery{%c_i%}{\n}
if not "%product%"=="" ECHO. & ECHO.[%model%]
ECHO.
ECHO.1.[������Դ]ˢ�������Recovery
ECHO.2.ˢ���Զ���Recovery
ECHO.A.�������˵�
call choice common [1][2][A]
if "%choice%"=="A" goto REC-DONE
if "%choice%"=="1" goto REC-1
if "%choice%"=="2" goto REC-
:REC-1
if "%product%"=="" ECHOC {%c_e%}����ѡ���ͺ���ʹ�ô˹���. {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul & goto REC-DONE
ECHOC {%c_h%}���밲׿�汾(��10,11,����ϵͳ�汾��), ��Enter����: {%c_i%}& set /p androidver=
if "%androidver%"=="" goto REC-1
call log %logger% I ���밲׿�汾:%androidver%
ECHO.����Recovery... & call dl direct %dlsource%/rec/%product%/%androidver%.7z %framwork_workspace%\tmp\rec.7z once noprompt
if not "%dl__result%"=="y" ECHOC {%c_e%}����ʧ��{%c_i%}{\n}& goto REC-1
ECHO.��ѹRecovery... & 7z.exe x -aoa -otmp tmp\rec.7z 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ѹʧ��{%c_i%}{\n}&& goto REC-1
ECHOC {%c_h%}�뽫�豸����Fastbootģʽ{%c_i%}{\n}& call chkdev fastboot rechk 1
ECHO.ˢ��Recovery... & call write fastboot recovery %framwork_workspace%\tmp\rec.img
ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul & goto REC-DONE
:REC-DONE
call log %logger% I ��ɹ���:ˢ�������Recovery
ENDLOCAL
goto MENU


:ROOT
SETLOCAL
set logger=viQOO������.bat-root
call log %logger% I ���빦��:Root��ȡ��Root
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Root��ȡ��Root
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_w%}ע��: ѡ�������ͺ�, boot��ϵͳ�汾���ܵ����豸�޷�����{%c_i%}{\n}
if not "%product%"=="" ECHO. & ECHO.[%model%]
ECHO.
ECHO.1.[������Դ]��ȡRoot
ECHO.2.[������Դ]�ָ��ٷ�boot,ȡ��Root
ECHO.3.ѡ���Զ���boot
ECHO.A.�������˵�
call choice common [1][2][3][A]
if "%choice%"=="A" goto ROOT-DONE
if "%choice%"=="3" goto ROOT-2
if "%choice%"=="1" set func=root& goto ROOT-1
if "%choice%"=="2" set func=unroot& goto ROOT-1
:ROOT-1
if "%product%"=="" ECHOC {%c_e%}����ѡ���ͺ���ʹ�ô˹���. {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul & goto ROOT-DONE
ECHOC {%c_h%}����ϵͳ�汾��, ��Enter����: {%c_i%}& set /p systemver=
if "%systemver%"=="" goto ROOT-1
call log %logger% I ����汾��:%systemver%
ECHO.����boot... & call dl direct %dlsource%/boot/%product%/%systemver%.7z %framwork_workspace%\tmp\boot.7z once noprompt
if not "%dl__result%"=="y" ECHOC {%c_e%}����ʧ��{%c_i%}{\n}& goto ROOT-1
ECHO.��ѹboot... & 7z.exe x -aoa -otmp tmp\boot.7z 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ѹʧ��{%c_i%}{\n}&& goto ROOT-1
if "%func%"=="root" call imgkit magiskpatch %framwork_workspace%\tmp\boot.img %framwork_workspace%\tmp\boot.img 25200 noprompt
goto ROOT-3
:ROOT-2
ECHOC {%c_h%}��ѡ��boot�ļ�...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
ECHO.�Ƿ���Magisk�޲��Ի�ȡRoot?
ECHO.1.�޲�   2.���޲�, ֱ��ˢ��
call choice common [1][2]
if "%choice%"=="2" echo.F|xcopy /Y %sel__file_path% tmp\boot.img 1>>%logfile% 2>&1 & goto ROOT-3
ECHO.1.ʹ�����õ�Magisk25200�汾�޲�   2.�Լ�ѡ��MagiskAPK
call choice common [1][2]
if "%choice%"=="1" set var=25200
if "%choice%"=="2" set var=%sel__file_path%
call imgkit magiskpatch %var% %framwork_workspace%\tmp\boot.img 25200 noprompt
goto ROOT-3
:ROOT-3
ECHO.��ѡ��������ʽ
ECHO.1.ֱ��ˢ��: ֱ��ˢ��boot����������
ECHO.2.��ʱ����: ֻ������ˢ��,�������ָ�,�ɲ���boot�Ƿ����.��ʱ����ʧ��˵���豸��֧����ʱ����,�����ɹ�������һ��,����Fastboot�򿪻��������Զ�����˵����boot������
call choice common [1][2]
if "%choice%"=="1" set var=flash
if "%choice%"=="2" set var=boot
ECHOC {%c_h%}�뽫�豸��������USB���Ի����Fastbootģʽ{%c_i%}{\n}& call chkdev all rechk 2
if "%chkdev__all__mode%"=="system" call reboot %chkdev__all__mode% fastboot rechk 1& goto ROOT-4
if "%chkdev__all__mode%"=="fastboot" goto ROOT-4
ECHOC {%c_e%}ģʽ����, �����ϵͳ��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ROOT-3
:ROOT-4
if "%var%"=="flash" ECHO.ˢ��boot... & call write fastboot boot %framwork_workspace%\tmp\boot.img
if "%var%"=="boot" ECHO.��ʱ����boot... & call write fastbootboot %framwork_workspace%\tmp\boot.img
ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul & goto ROOT-DONE
:ROOT-DONE
call log %logger% I ��ɹ���:Root��ȡ��Root
ENDLOCAL
goto MENU


:UNLOCKBL
SETLOCAL
set logger=viQOO������.bat-unlockbl
call log %logger% I ���빦��:����BL��
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.����BL��
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��ʾ: ���ڹٷ��Ѿ�ͨ��ϵͳ���·�º���, ����ʧ��������������.
ECHO.
ECHO.ȷ��Ҫ����BL��ô? ����ˢ�������������Ӱ��:
ECHO.�ֻ����ݱ����
ECHO.�ֻ�ϵͳ���޷�����
ECHO.������ʧ
ECHO.ʧȥ����
ECHO.��ѧָ��ʧЧ(�����ۺ�У׼�ָ�)
ECHO.ָ��֧��������(�������ͨ��ģ���޸�)
ECHO....
call choice twochoice ��Ը�е����Ϸ���.������1��Enter����.����ֱ�Ӱ�Enter�������˵�:
if not "%choice%"=="1" goto UNLOCKBL-DONE
ECHO.
ECHO.��رղ����ֻ�, �˳�vivo�˺�, ����������ѡ���е�OEM����, Ȼ���豸������������һ��ģʽ:
ECHO.- ����״̬������USB����
ECHO.- Fastbootģʽ
ECHO.
:UNLOCKBL-1
call chkdev all rechk 2
if "%chkdev__all__mode%"=="system" call reboot %chkdev__all__mode% fastboot rechk 1& goto UNLOCKBL-2
if "%chkdev__all__mode%"=="fastboot" call reboot %chkdev__all__mode% fastboot rechk 1& goto UNLOCKBL-2
ECHOC {%c_e%}ģʽ����, �����ϵͳ��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto UNLOCKBL-1
:UNLOCKBL-2
ECHO.��ȡ�豸��Ϣ... & call log %logger% I ��ȡ�豸��Ϣ& call info fastboot
if "%info__fastboot__unlocked%"=="y" ECHOC {%c_s%}����豸�Ѿ�����. {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-DONE
ECHO.����ˢ��vendor... & call log %logger% I ����ˢ��vendor& fastboot.exe flash vendor %vendor.img% 1>>%logfile% 2>&1 && ECHO.ˢ��ɹ�
set var=n
ECHO.���Խ���BL... & call log %logger% I ���Խ���BL& fastboot_vivo.exe vivo_bsp unlock_vivo 1>>%logfile% 2>&1 && set var=y
if "%var%"=="n" ECHOC {%c_e%}����ʧ��. {%c_i%}ϵͳû�л��ѷ�´˺���. �鿴%logfile%�Ի����ϸ��Ϣ. {%c_h%}��������������˵�...{%c_i%}{\n}
if "%var%"=="y" ECHOC {%c_s%}�����ɹ�. {%c_i%}����޷�����, ���ֶ�����Recovery������ݻָ�����. {%c_h%}��������������˵�...{%c_i%}{\n}
pause>nul & goto UNLOCKBL-DONE
:UNLOCKBL-DONE
call log %logger% I ��ɹ���:����BL��
ENDLOCAL
goto MENU


:ALETTER
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.viQOO������
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.����:
ECHO.
ECHO.    ���. ��������, ����viQOO�������ȫ�°汾. ��ֹͣά������һ���ʱ��֮��, ��������Ϊ���ع����������°�. ����ԭ��, ������Ȼ�벻����λ���͵�֧��. ���ǵİ������ǵķ�����. ���, ��Ҳ�������ҽ��ڱ�д��BFF���, ʹ�����ܿ������������ʵ�ˢ��������. ���, �Ҹ��˼����ϵĽ���Ҳ��ԭ��֮һ.
ECHO.    ˵������, ��ʱ��viQOO�����˺ܶ��µ�д������Ʒ�ʽ, ���Ū�ĺ���, �������޷���ά����ȥ. �����ⲻ������Ҫ��, ����Ļ�����Ϊ, vivo����������δ��, ����������Ϊ��. �����ǹٷ��ĺ���, ����©��, �����ƽ�. �ٷ���ʱ���Է��, ����ʵ������Ҳ�ܿ���������. �ܽ������豸ֻ��Խ��Խ��, ��ע����һ��û��ϣ������Ŀ.
ECHO.    �Ҳ�֪��������ȥ���ж�������, Ҳ��ֻ��Ϊ�������֮һ�Ŀ��ܰ�. ���������ܰ����������֮һ, ��Ҳ����û������. ����һ���˵ľ��������޵�, �Ҹ�Ӧ����ֵ�õ���Ŀ��Ͷ�����, ���Ǳ�Ȼ��.
ECHO.    ��������.
ECHO.
ECHO.                                                                  ĳ��
ECHO.                                                                2023.6
pause>nul
goto MENU


:SELDEV
SETLOCAL
set logger=viQOO������.bat-seldev
call log %logger% I ���빦��:ѡ���ͺ�
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.ѡ���ͺ�
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.����������ȡ�ͺ��б�...
::call dl lzlink https://syxz.lanzoub.com/iKWrI0ynhjva %framwork_workspace%\tmp\dev.csv retry noprompt [1]
call dl direct %dlsource%/dev.csv %framwork_workspace%\tmp\dev.csv retry noprompt [1]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.ѡ���ͺ�
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
type tmp\dev.csv
ECHO.[A],�������˵�
ECHO.
:SELDEV-1
ECHOC {%c_h%}�������, ��Enter����: {%c_i%}& set /p choice=
if "%choice%"=="" goto SELDEV-1
if "%choice%"=="A" goto SELDEV-DONE
if "%choice%"=="a" goto SELDEV-DONE
find "[%choice%]," "tmp\dev.csv" 1>nul 2>nul || goto SELDEV-1
for /f "tokens=2,3 delims=," %%a in ('find "[%choice%]," "tmp\dev.csv"') do (set product=%%a& set model=%%b)
call framwork conf user.bat product %product%
call framwork conf user.bat model %model%
call log %logger% I ѡ���ͺ�:%product%.%model%
goto SELDEV-DONE
:SELDEV-DONE
ENDLOCAL & set product=%product%& set model=%model%
goto MENU


:LOG
SETLOCAL
set logger=viQOO������.bat-log
call log %logger% I ���빦��LOG
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.������־
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%framwork_log%"=="y" (ECHO.1.[��ǰ]������־) else (ECHO.1.      ������־)
if "%framwork_log%"=="n" (ECHO.2.[��ǰ]�ر���־) else (ECHO.2.      �ر���־)
call choice common [1][2]
if "%choice%"=="1" call framwork conf framwork.bat framwork_log y
if "%choice%"=="2" call framwork conf framwork.bat framwork_log n
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SLOT& pause>nul & goto MENU


:THEME
SETLOCAL
set logger=viQOO������.bat-theme
call log %logger% I ���빦��THEME
:THEME-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.����
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.Ĭ��
ECHO.2.����
ECHO.3.�ڰ�ͼ
ECHO.4.�����ڿ�
ECHO.5.����
ECHO.6.DOS
ECHO.7.�����
ECHO.A.�������˵�
call choice common [1][2][3][4][5][6][7][A]
if "%choice%"=="1" set target=default
if "%choice%"=="2" set target=classic
if "%choice%"=="3" set target=ubuntu
if "%choice%"=="4" set target=douyinhacker
if "%choice%"=="5" set target=gold
if "%choice%"=="6" set target=dos
if "%choice%"=="7" set target=ChineseNewYear
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���THEME& goto MENU
::����Ԥ��
call framwork theme %target%
echo.@ECHO OFF>tmp\theme.bat
echo.mode con cols=50 lines=15 >>tmp\theme.bat
echo.cd ..>>tmp\theme.bat
echo.set path=%framwork_workspace%;%framwork_workspace%\tool\Windows;%framwork_workspace%\tool\Android;%path% >>tmp\theme.bat
echo.COLOR %c_i% >>tmp\theme.bat
echo.TITLE ����Ԥ��: %target% >>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_i%}��ͨ��Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_w%}������Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_e%}������Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_s%}�ɹ���Ϣ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_h%}�ֶ�������ʾ{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.pause^>nul>>tmp\theme.bat
echo.EXIT>>tmp\theme.bat
call framwork theme
start tmp\theme.bat
::����Ԥ�����
ECHO.
ECHO.�Ѽ���Ԥ��. �Ƿ�ʹ�ø�����
ECHO.1.ʹ��   2.��ʹ��
call choice common [1][2]
if "%choice%"=="1" call framwork conf framwork.bat framwork_theme %target%& ECHOC {%c_i%}�Ѹ�������, ���´򿪽ű���Ч. {%c_h%}��������رսű�...{%c_i%}{\n}& call log %logger% I ��������Ϊ%target%& pause>nul & EXIT
if "%choice%"=="2" goto THEME-1


:UPDATE
SETLOCAL
set logger=viQOO������.bat-update
call log %logger% I ���빦��UPDATE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.������
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.���ڼ�����...
call dl direct https://syxz.lanzouj.com/b01ey8k6j %framwork_workspace%\tmp\update.txt retry noprompt viqoo_update
for /f "tokens=2 delims=[]" %%i in ('find "viqoo_update" "tmp\update.txt"') do set var=%%i
call dl lzlink %var% %framwork_workspace%\tmp\update.txt retry noprompt [program]
for /f "tokens=2,3,4 delims=," %%a in ('find "[program]" "tmp\update.txt"') do (set prog_ver_new=%%a& set update_log=%%b& set update_lzlink=%%c)
if "%prog_ver%"=="%prog_ver_new%" ECHOC {%c_i%}�������������°汾(V%prog_ver_new%). {%c_h%}��������������˵�...{%c_i%}{\n}& pause>nul & ENDLOCAL & goto MENU
ECHO.
ECHO.%prog_ver% - %prog_ver_new%
ECHO.%update_log%
ECHO.
ECHOC {%c_h%}���������ʼ����(��ǿ�ƽ�������ˢ������)...{%c_i%}{\n}& pause>nul
ECHO.���ظ��°�... & call dl lzlink %update_lzlink% %framwork_workspace%\tmp\update.7z retry noprompt
ECHO.���ɸ��½ű�...
echo.TITLE viQOO����������� ����رմ���...>tmp\update.bat
echo.taskkill /f /im adb.exe>>tmp\update.bat
echo.taskkill /f /im fastboot.exe>>tmp\update.bat
echo.7z.exe x -aoa -o.. tmp\update.7z>>tmp\update.bat
echo.exit>>tmp\update.bat
ECHO.�������½ű�... & start tmp\update.bat & EXIT











:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
