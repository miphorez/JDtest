unit CallJava;
interface
uses
    JNI, Windows, SysUtils, Forms;

const
     //������������ ����� � �������� Java
     //������������ �������� ����� � ����������
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
    //� ��������� ���������� PATCH ������ ���� ���������
    //���� � �����, ��� ���������� jvm.dll
    iJavaVM := TJavaVM.Create();
    if iJavaVM = nil then begin
      strErr:= '������ �������� JavaVM';
      Exit;
    end;

    //� JAVA_CLASS_DIR ���������� ��������� ���� � ����� � �������� Java
    CurrentDir:= ExtractFilePath(Application.ExeName);
    Options[0].optionString:= PChar('-Djava.class.path='+
                               CurrentDir+JAVA_CLASS_DIR);
    VM_args.version := JNI_VERSION_1_2;
    VM_args.options := @Options;
    VM_args.nOptions := 1;

    //��������� VM Java
    Errcode := iJavaVM.LoadVM(VM_args);
    if Errcode < 0 then begin
      strErr:= Format('������ �������� JavaVM: %d', [Errcode]);
      Exit;
    end;

    //�������� java ���������
    iJNIEnv := TJNIEnv.Create(iJavaVM.Env);
    if iJNIEnv = nil then begin
      strErr:= '������ �������� ��������� JavaVM';
      Exit;
    end;

except
    on E : Exception do begin
      strErr:= Format('���������� ������ JavaVM: %s', [E.Message]);
    end;
end;
end;

function getJavaClass(strClass: string): JClass;
begin
strErr:='';
result:= nil;
try
    //����� ����� � ����� � �������� �� ������� ���� ������
    result := iJNIEnv.FindClass(PChar(strClass));
    if result = nil then begin
      strErr:= Format('�� ������ �����: %s', [strClass]);
      Exit;
    end;
except
    on E : Exception do begin
      strErr:= Format('������:'+#13+
      '%s'+#13+
      '� ������:'+#13+
      '%s', [E.Message, strClass]);
    end;
end;
end;

end.
