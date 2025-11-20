unit uDm;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, System.ImageList,
  FMX.ImgList, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.IOUtils;

type
  TUser = class(TObject)
    IDH: Integer;
    RoleH: String;
    UsernameH: String;
    PasswordH: String;
    EmailH: String;
    PhoneH: String;
    BioH: String;
    FullnameH: String;
  end;
  Tdm = class(TDataModule)
    sbDental: TStyleBook;
    imgList: TImageList;
    conDental: TFDConnection;
    qPatients: TFDQuery;
    qUsers: TFDQuery;
    qTemp: TFDQuery;
    qAppointments: TFDQuery;
    qPatientSelection: TFDQuery;
    qTodaysAppointment: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FUser: TUser;
  public
    FormReader: String;
    RecordStatus: String;
    property User: TUser read FUser write FUser;
//    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses uLogin;

{$R *.dfm}

procedure EnsureDatabaseExists;
var
  SourcePath, TargetPath: string;
begin
  TargetPath := TPath.Combine(TPath.GetHomePath, 'Roces Dental\dental.db');
  if not TFile.Exists(TargetPath) then
  begin
    // Path to where you install the template db (in Program Files directory)
    SourcePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'database\dental.db');
    TDirectory.CreateDirectory(TPath.GetDirectoryName(TargetPath));
    TFile.Copy(SourcePath, TargetPath);
  end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
var
  DBDir, DBPath: String;
begin
  // Database checker
  EnsureDatabaseExists;

  // Class
  FUser := TUser.Create;

  // Connection clearing
  conDental.Connected := False;
  conDental.Params.Values['Database'] := '';

  {$IFDEF DEBUG}
  // Get the directory of the executable relative path
  DBPath := ExtractFilePath(ParamStr(0)) + 'database\dental.db';
  {$ENDIF}

  {$IFDEF RELEASE}
  // Get user appdata directory
  DBDir := TPath.Combine(TPath.GetHomePath, 'Roces Dental');
  TDirectory.CreateDirectory(DBDir); // creates if missing
  DBPath := TPath.Combine(DBDir, 'dental.db');
  {$ENDIF}

  conDental.Params.Values['DriverID'] := 'SQLite';
  conDental.Params.Values['Database'] := DBPath;

  // Deactivate queries
  qUsers.Close;
  qPatients.Close;
  qAppointments.Close;
  qTodaysAppointment.Close;
  qPatientSelection.Close;
  qTemp.Close;

  // activate connection
  conDental.Connected := True;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FUser.Free;
end;

end.
