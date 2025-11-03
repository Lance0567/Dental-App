unit uGlobal;

interface

uses
  System.SysUtils, System.Classes, FMX.Layouts, System.Types, FMX.DialogService,
  System.UITypes, FireDAC.Stan.Param, System.IOUtils, System.IniFiles;

procedure AdjustLayoutHeight(ALayout: TLayout; AHeight: Single);
procedure QueryExistingUsername;
function LoadRememberMeUsername: string;

implementation

uses uDm, uMain;

{ Adjust Layout height for modal required fields }
procedure AdjustLayoutHeight(ALayout: TLayout; AHeight: Single);
begin
  if Assigned(ALayout) then
  begin
    ALayout.Height := AHeight;
  end;
end;

{ Query for checking existing username }
procedure QueryExistingUsername;
var
  UsernameExist: Boolean;
begin
  try
    dm.qTemp.Close;
    dm.qTemp.SQL.Text :=
    'SELECT COUNT(*) AS cnt ' +
    'FROM users WHERE username = :username';
    dm.qTemp.ParamByName('username').AsString := frmMain.fUserModal.eUsername.Text;
    dm.qTemp.Open;

    UsernameExist := dm.qTemp.FieldByName('cnt').AsInteger > 0;
    dm.qTemp.Close;

    if UsernameExist then
    begin
      TDialogService.MessageDialog(
        'Username already exists. Please choose a different username.',
        TMsgDlgType.mtError,  // info icon
        [TMsgDlgBtn.mbOK],
        TMsgDlgBtn.mbOK, 0,
        nil  // No callback, so code continues immediately
      );
      frmMain.fUserModal.HasError := True;
    end;
  finally
    // Optional: free resources or handle exceptions if needed
  end;
end;

{ Load Remember Me }
function LoadRememberMeUsername: string;
var
  Ini: TMemIniFile;
  IniFileName: string;
begin
  IniFileName := TPath.Combine(TPath.GetHomePath, 'MyAppSettings.ini');
  if FileExists(IniFileName) then
  begin
    Ini := TMemIniFile.Create(IniFileName);
    try
      Result := Ini.ReadString('Login', 'Username', '');
    finally
      Ini.Free;
    end;
  end
  else
    Result := '';
end;


end.
