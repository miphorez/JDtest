program JDtest;

uses
  JNIUtils in 'units\JNIUtils.pas',
  CallJava in 'units\CallJava.pas',
  JNI in 'units\JNI.pas',
  Windows, SysUtils;

var
  strMetod, strSign, strArg, strResult:string;
  isStaticMetod: boolean;
  jCls: JClass;
begin
try

  //запускJavaVM
  CallJava.createJavaEnv();
  if CallJava.strErr<>'' then begin
    MessageBox(0, PChar(Format('Ошибка: %s', [CallJava.strErr])),
    'Error JVM',MB_ICONERROR);
    Exit;
  end;

  //обращение к Java-классу:
  //перед именем класса обязательно указать расположение пакета, заменив "." на "/"
  jCls:= CallJava.getJavaClass('com/test/javafordelphi/JavaClassForDelphiTest');
  if CallJava.strErr<>'' then begin
    MessageBox(0, PChar(Format('Ошибка: %s', [CallJava.strErr])),
    'Error JVM',MB_ICONERROR);
    Exit;
  end;

  //вызов метода из класса
  strMetod:= 'goTest';
  strSign:= 'String (String)';
  strArg:= '123';
  isStaticMetod:= true;
  strResult := JNIUtils.CallMethod(CallJava.iJNIEnv, jCls,
            strMetod, strSign, [strArg],
            isStaticMetod);
  //результат
  if strResult<>'' then
    MessageBox(0, PChar(strResult), '',MB_OK) else
    MessageBox(0, PChar(Format('Ошибка вызова метода: %s', [strMetod])),
    'Error JVM',MB_ICONERROR);

except
  on E : Exception do begin
    MessageBox(0, PChar(Format('Непредвиденная ошибка: %s', [E.Message])),
    'Error JVM',MB_ICONERROR);
  end;
end;

end.