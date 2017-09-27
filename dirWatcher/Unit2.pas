unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShlObj, ActiveX, StdCtrls;


type
  TMainForm = class(TForm)
    Memo1: TMemo;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDirectoryHandle: THandle;
    FNotificationBuffer: array[0..4096] of Byte;
    FWatchThread: TThread;
    FNotifyFilter: DWORD;
    FOverlapped: TOverlapped;
    FPOverlapped: POverlapped;
    FBytesWritten: DWORD;
    FCompletionPort: THandle;
  public
    { Public declarations }
    procedure start;
    procedure stop;
  end;


var
  MainForm: TMainForm;

implementation

type
  PFileNotifyInformation = ^TFileNotifyInformation;
  TFileNotifyInformation = Record
    NextEntryOffset: DWORD;
    Action: DWORD;
    FileNameLength: DWORD;
    FileName: Array[0..0] of WideChar;
  End;

const
  FILE_LIST_DIRECTORY   = $0001;
  cDir = 'c:\codit\teste'; // The directory to monitor

type
  TWaitThread = class(TThread)
  private
    FForm: TMainForm;


    procedure HandleEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(Form: TMainForm);
  end;


procedure TWaitThread.HandleEvent;
  Var
  FileOpNotification: PFileNotifyInformation;
  Offset: Longint;
  F: String;
  AList: TStringList;
  I: Integer;
begin

  AList := TStringList.Create;

  Try

    With FForm Do
    Begin

      Pointer(FileOpNotification) := @FNotificationBuffer[0];

      Repeat
        Offset := FileOpNotification^.NextEntryOffset;
        //lbEvents.Items.Add(Format(SAction[FileOpNotification^.Action], [WideCharToString(@(FileOpNotification^.FileName))]));

        F := cDir + WideCharToString(@(FileOpNotification^.FileName));

        if AList.IndexOf(F) < 0 Then
        AList.Add(F);

        PChar(FileOpNotification) := PChar(FileOpNotification)+Offset;

      Until Offset=0;

      For I := 0 To AList.Count -1 Do
      // do whatever you need

    End;

  Finally
    AList.Free;
  End;

end;


constructor TWaitThread.Create(Form: TMainForm);
begin
  inherited Create(True);
  FForm := Form;
  FreeOnTerminate := False;
end;

procedure TWaitThread.Execute;
  Var
  NumBytes: DWORD;
  CompletionKey: DWORD;
begin

  While Not Terminated Do
  Begin

    GetQueuedCompletionStatus( FForm.FCompletionPort, numBytes, CompletionKey, FForm.FPOverlapped, INFINITE);

    if CompletionKey <> 0 Then
    Begin
      Synchronize(HandleEvent);

      With FForm do
      begin
        FBytesWritten := 0;
        ZeroMemory(@FNotificationBuffer, SizeOf(FNotificationBuffer));
        ReadDirectoryChanges(FDirectoryHandle, @FNotificationBuffer, SizeOf(FNotificationBuffer), False, FNotifyFilter, @FBytesWritten, @FOverlapped, nil);
      End;

    End
    Else
    Terminate;

  End;

end;


{$R *.dfm}

{ TMainForm }

procedure TMainForm.start;
begin
  FNotifyFilter := 0;

  FNotifyFilter := FNotifyFilter or FILE_NOTIFY_CHANGE_FILE_NAME;

  FDirectoryHandle := CreateFile(cDir,
                      FILE_LIST_DIRECTORY,
                      FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE,
                      Nil,
                      OPEN_EXISTING,
                      FILE_FLAG_BACKUP_SEMANTICS or FILE_FLAG_OVERLAPPED,
                      0);

  if FDirectoryHandle = INVALID_HANDLE_VALUE Then
  Begin
    Beep;
    FDirectoryHandle := 0;
    ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  End;

  FCompletionPort := CreateIoCompletionPort(FDirectoryHandle, 0, Longint(pointer(self)), 0);
  ZeroMemory(@FNotificationBuffer, SizeOf(FNotificationBuffer));
  FBytesWritten := 0;

  if Not ReadDirectoryChanges(FDirectoryHandle, @FNotificationBuffer, SizeOf(FNotificationBuffer), False, FNotifyFilter, @FBytesWritten, @FOverlapped, Nil) Then
  Begin
    CloseHandle(FDirectoryHandle);
    FDirectoryHandle := 0;
    CloseHandle(FCompletionPort);
    FCompletionPort := 0;
    ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  End;

  FWatchThread := TWaitThread.Create(self);
  TWaitThread(FWatchThread).Resume;
end;

procedure TMainForm.stop;
begin
  if FCompletionPort = 0 Then
  Exit;

  PostQueuedCompletionStatus(FCompletionPort, 0, 0, Nil);
  FWatchThread.WaitFor;
  FWatchThread.Free;
  CloseHandle(FDirectoryHandle);
  FDirectoryHandle := 0;
  CloseHandle(FCompletionPort);
  FCompletionPort := 0;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FCompletionPort := 0;
  FDirectoryHandle := 0;
  FPOverlapped := @FOverlapped;
  ZeroMemory(@FOverlapped, SizeOf(FOverlapped));

  Start;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  stop;
end;



end.
