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
  Tpatients = class(TObject)

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
var
  DBPath: String;
begin
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

  // activate connection
  conDental.Connected := True;
end;

end.
