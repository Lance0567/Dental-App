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
    Layout2: TLayout;
    btnNewPatient: TCornerButton;
    btnNewAppointment: TCornerButton;
    lytBottom: TLayout;
    btnReportAnIssue: TCornerButton;
    rToolbar: TRectangle;
    lytToolbarH: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    RoundRect1: TRoundRect;
    lBevel: TLine;
    procedure FrameResize(Sender: TObject);
  private

    { Private declarations }
  public
    procedure CardsResize;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain;

{ Frame Resize }
procedure TfDashboard.FrameResize(Sender: TObject);
begin
  // Cards width responsive
  if frmMain.ClientWidth > 1900 then
  begin
    glytCards.ItemWidth := 320;
    glytCards.Padding.Right := 0;
    glytCards.Padding.Left := 0;
  end
  else if (frmMain.ClientHeight <= 505) and (frmMain.ClientWidth <= 800) then
  begin
    glytCards.Height := 420;
  end
  else
  begin
    glytCards.ItemWidth := 270;
  end;

  // Cards height responsive
  if frmMain.ClientHeight < 510 then
  begin
    glytCards.Height := 300;
  end
  else
  begin
    glytCards.Height := 160;
  end;
end;

{ Card Resize }
procedure TfDashboard.CardsResize;
var
  AvailableWidth: Integer;
  ItemsPerRow: Integer;
begin
  AvailableWidth := Trunc(glytCards.Width);

  // Device Dimension setter
  if frmMain.Width > 1900 then   // Dimension greater than 1900
  begin
    glytCards.Width := 1660;
  end
  else
  begin
    glytCards.Width := 275;
  end;

  // Dimension condition
  if frmMain.ClientWidth > 1900 then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 400);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
  end
  else if (frmMain.ClientWidth > 840) AND (frmMain.ClientWidth < 1300) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 290);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
  end
  else if (frmMain.ClientWidth < 840) OR (frmMain.ClientWidth > 1300) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 265);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
  end;
end;

end.
