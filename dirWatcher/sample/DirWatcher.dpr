program DirWatcher;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form2},
  dirWatcherLib in '..\dirWatcherLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
