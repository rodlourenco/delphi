unit dirWatcherLib;

interface

type
  TNotifyChange = procedure(const path: string) of object;

  IDirWatcher = Interface
    ['{6D0BD0AC-1BA7-47D0-8872-BDA62470524B}']
    procedure Setactive(const Value: boolean);
    function GetActive: boolean;
    procedure SetinitialDir(const Value: string);
    function GetinitialDir: string;
    procedure setNotifyChange(const Value: TNotifyChange);

    property active: boolean read GetActive write SetActive;
    property initialDir: string read GetinitialDir write SetinitialDir;
    property onNotifyChange: TNotifyChange write setNotifyChange;
  end;

function getDirWatcher(const initialDir: string; const start: boolean = true): IDirWatcher;


implementation

type
  TDirWatcher = class(TInterfacedObject, IDirWatcher)
  private
    FNotifyEvent: TNotifyChange;
    FinitialDir: string;
    Factive: boolean;

    procedure start;
    procedure stop;

    procedure startWatcher(const dir: string);

  public
    procedure BeforeDestruction; override;

    procedure Setactive(const Value: boolean);
    function GetActive: boolean;
    procedure SetinitialDir(const Value: string);
    function GetinitialDir: string;
    procedure setNotifyChange(const Value: TNotifyChange);

    property active: boolean read GetActive write SetActive;
    property initialDir: string read GetinitialDir write SetinitialDir;
    property onNotifyChange: TNotifyChange write setNotifyChange;
  end;

{ TDirWatcher }

procedure TDirWatcher.BeforeDestruction;
begin
  stop;

  inherited;
end;

function TDirWatcher.GetActive: boolean;
begin
  Result := Factive;
end;

function TDirWatcher.GetinitialDir: string;
begin
  result := FinitialDir;
end;

procedure TDirWatcher.Setactive(const Value: boolean);
begin
  if Value and not Factive then
  begin
    start;
    Factive := true;
  end
  else if not Value then
  begin
    stop;
    Factive := false;
  end;
end;

procedure TDirWatcher.SetinitialDir(const Value: string);
begin
  FinitialDir := Value;
end;

procedure TDirWatcher.setNotifyChange(const Value: TNotifyChange);
begin
  FNotifyEvent := value;
end;

procedure TDirWatcher.start;
begin
  //1 - Verifica se o diretorio inicial é valido, se nao for abort a inicializacao e lança uma exceção

  //2 - Inicia o monitoramento do diretório inicial
  startWatcher(initialDir);
end;

procedure TDirWatcher.startWatcher(const dir: string);
begin
  //Inicia monitoramento no diretório atual

  //Obtem lista de subdiretórios do diretório atual e inicia monitoriamento nos subdiretórios
end;

procedure TDirWatcher.stop;
begin
  //Para todos os monitoramentos de diretórios
end;

function getDirWatcher(const initialDir: string; const start: boolean = true): IDirWatcher;
begin
  result := TDirWatcher.Create as IDirWatcher;
  result.initialDir := initialDir;
  if start then
    result.active := true;
end;


end.
