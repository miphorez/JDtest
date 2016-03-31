unit CallJava;
interface
uses
    JNI, Windows, SysUtils, Forms;

const
     //расположение папки с классами Java
     //относительно корневой папки с программой
     JAVA_CLASS_DIR = 'classes';

    procedure createJavaEnv();
    function getJavaClass(strClass: string): JClass;

var
    iJavaVM: TJavaVM;
    iJNIEnv: TJNIEnv;
    strErr: string;

implementation

{ TCallJava }

procedure createJavaEnv;
var
  Options: array [0..4] of JavaVMOption;
  VM_args: JavaVMInitArgs;
  Errcode: Integer;
  CurrentDir: string;
begin
strErr:= '';
try
    //в системной переменной PATCH должен быть прописать
    //путь к папке, где содержится jvm.dll
    iJavaVM := TJavaVM.Create();
    if iJavaVM = nil then begin
      strErr:= 'Ошибка создания JavaVM';
      Exit;
    end;

    //в JAVA_CLASS_DIR необходимо прописать путь к папке с классами Java
    CurrentDir:= ExtractFilePath(Application.ExeName);
    Options[0].optionString:= PChar('-Djava.class.path='+
                               CurrentDir+JAVA_CLASS_DIR);
    VM_args.version := JNI_VERSION_1_2;
    VM_args.options := @Options;
    VM_args.nOptions := 1;

    //загрузить VM Java
    Errcode := iJavaVM.LoadVM(VM_args);
    if Errcode < 0 then begin
      strErr:= Format('Ошибка загрузки JavaVM: %d', [Errcode]);
      Exit;
    end;

    //создание java окружения
    iJNIEnv := TJNIEnv.Create(iJavaVM.Env);
    if iJNIEnv = nil then begin
      strErr:= 'Ошибка создания окружения JavaVM';
      Exit;
    end;

except
    on E : Exception do begin
      strErr:= Format('Внутренняя ошибка JavaVM: %s', [E.Message]);
    end;
end;
end;

function getJavaClass(strClass: string): JClass;
begin
strErr:='';
result:= nil;
try
    //найти класс в папке с классами по полному пути пакета
    result := iJNIEnv.FindClass(PChar(strClass));
    if result = nil then begin
      strErr:= Format('Не найден класс: %s', [strClass]);
      Exit;
    end;
except
    on E : Exception do begin
      strErr:= Format('Ошибка:'+#13+
      '%s'+#13+
      'в классе:'+#13+
      '%s', [E.Message, strClass]);
    end;
end;
end;

end.
