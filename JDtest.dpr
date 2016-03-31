program JDtest;

uses
  JNIUtils in 'units\JNIUtils.pas',
  CallJava in 'units\CallJava.pas',
  JNI in 'units\JNI.pas',
  Windows, SysUtils, Forms;

var
  strMetod, strSign, strArg, strResult:string;
  isStaticMetod: boolean;
  jCls: JClass;
begin
try

  //������JavaVM
  CallJava.createJavaEnv();
  if CallJava.strErr<>'' then begin
    Application.MessageBox(PChar(Format('������: %s', [CallJava.strErr])),
    'Error JVM',MB_ICONERROR);
    Exit;
  end;

  //��������� � Java-������:
  //����� ������ ������ ����������� ������� ������������ ������, ������� "." �� "/"
  jCls:= CallJava.getJavaClass('com/test/javafordelphi/JavaClassForDelphiTest');
  if CallJava.strErr<>'' then begin
    Application.MessageBox(PChar(Format('������: %s', [CallJava.strErr])),
    'Error JVM',MB_ICONERROR);
    Exit;
  end;

  //����� ������ �� ������
  strMetod:= 'goTest';
  strSign:= 'String (String)';
  strArg:= '123';
  isStaticMetod:= true;
  strResult := JNIUtils.CallMethod(CallJava.iJNIEnv, jCls,
            strMetod, strSign, [strArg],
            isStaticMetod);
  //���������
  if strResult<>'' then
    Application.MessageBox(PChar(strResult), 'JavaClassForDelphiTest.goTest',MB_OK) else
    Application.MessageBox(PChar(Format('������ ������ ������: %s', [strMetod])),
    'Error JVM',MB_ICONERROR);

except
  on E : Exception do begin
    Application.MessageBox(PChar(Format('�������������� ������: %s', [E.Message])),
    'Error JVM',MB_ICONERROR);
  end;
end;

end.