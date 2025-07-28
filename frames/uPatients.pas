unit uPatients;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Skia, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Edit, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid;

type
  TfPatients = class(TFrame)
    lytHeader: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    rToolbar: TRectangle;
    lytToolbarH: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    RoundRect1: TRoundRect;
    lBevel: TLine;
    lytComponents: TLayout;
    eSearch: TEdit;
    lytSearch: TLayout;
    lytButtonH: TLayout;
    btnAddNewPatient: TCornerButton;
    lytBottom: TLayout;
    gPatients: TGrid;
    ScrollBox1: TScrollBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uPatientModal;

end.
