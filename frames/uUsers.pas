unit uUsers;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  FMX.Objects, FMX.Skia, FMX.ImgList, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts;

type
  TfUsers = class(TFrame)
    ScrollBox1: TScrollBox;
    lytBottom: TLayout;
    lytComponents: TLayout;
    lytSearch: TLayout;
    eSearch: TEdit;
    lytButtonH: TLayout;
    btnAddNewUser: TCornerButton;
    lytHeader: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    rToolbar: TRectangle;
    lBevel: TLine;
    S: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rrUserImage: TRoundRect;
    rPatients: TRectangle;
    gPatients: TGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
