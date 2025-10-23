unit uDm;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, System.ImageList,
  FMX.ImgList, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TUser = class(TObject)
    RoleH: String;
    UsernameH: String;
    PasswordH: String;
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
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses uLogin;

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
var
  DBPath: String;
begin
  // Class
  FUser := TUser.Create;

  // Connection clearing
  conDental.Connected := False;
  conDental.Params.Values['Database'] := '';

  // Get the directory of the executable relative path
  DBPath := ExtractFilePath(ParamStr(0)) + 'database\dental.db';
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
