unit uDm;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls;

type
  Tdm = class(TDataModule)
    sbDental: TStyleBook;
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

end.
