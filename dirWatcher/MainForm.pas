unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  dirWatcherLib, StdCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    CheckBox1: TCheckBox;
    Label1: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDirWatcher: IDirWatcher;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation


{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  DirectoryListBox1.Directory := 'c:\';

  FDirWatcher := getDirWatcher('', false);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FDirWatcher.active := false;
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  if (CheckBox1.Checked) then
  begin
    FDirWatcher.initialDir := DirectoryListBox1.Directory;
    try
      FDirWatcher.active := true;
    except
      on e1: exception do
      begin
        CheckBox1.Checked := false;
        raise e1;
      end;

    end;

    CheckBox1.Caption := 'Watching '+DirectoryListBox1.Directory;
    DirectoryListBox1.Enabled := false;
  end
  else
  begin
    FDirWatcher.active := true;
    CheckBox1.Caption := 'Watch';
    DirectoryListBox1.Enabled := true;
  end;

end;



end.
