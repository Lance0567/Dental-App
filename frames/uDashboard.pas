unit uDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, System.Rtti, FMX.Grid.Style, FMX.Calendar, FMX.ScrollBox,
  FMX.Grid, FMX.Skia, FMX.ImgList, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, Math;

type
  TfDashboard = class(TFrame)
    ScrollBox1: TScrollBox;
    lytBottom: TLayout;
    glytCards: TGridLayout;
    lytHeader: TLayout;
    lbTitle: TLabel;
    rUrgentContracts: TRectangle;
    lbDescription: TLabel;
    lytTitle: TLayout;
    rCard1: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    rCard2: TRectangle;
    lytCardD2: TLayout;
    lbActiveClients: TLabel;
    lbActiveClientsC: TLabel;
    rCard3: TRectangle;
    lytCardD3: TLayout;
    lbFullyPaid: TLabel;
    lbFullyPaidC: TLabel;
    rCard4: TRectangle;
    lytCardD4: TLayout;
    lbPartiallyPaid: TLabel;
    lbPartiallyPaidC: TLabel;
    cIcon1: TCircle;
    gIcon1: TGlyph;
    cIcon2: TCircle;
    gIcon2: TGlyph;
    cIcon3: TCircle;
    gIcon3: TGlyph;
    cIcon4: TCircle;
    gIcon4: TGlyph;
    lytRecords: TLayout;
    rQuickActions: TRectangle;
    Layout3: TLayout;
    lbRecordedAppointments: TLabel;
    Layout4: TLayout;
    lbQuickActions: TLabel;
    Grid1: TGrid;
    btnReportIssue: TButton;
    rToolbar: TRectangle;
    lytToolbarH: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lBevel: TLine;
    lytUser: TLayout;
    Layout2: TLayout;
    btnNewPatient: TButton;
    btnNewAppointment: TButton;
    slUserName: TSkLabel;
    RoundRect1: TRoundRect;
    procedure glytCardsResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm;

procedure TfDashboard.glytCardsResize(Sender: TObject);
var
  AvailableWidth: Integer;
  ItemsPerRow: Integer;
begin
  AvailableWidth := Trunc(glytCards.Width);
  ItemsPerRow := Max(1, AvailableWidth div 265);
  glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
end;

end.
