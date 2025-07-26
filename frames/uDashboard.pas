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
    lbTotalPatients: TLabel;
    Label2: TLabel;
    rCard2: TRectangle;
    lytCardD2: TLayout;
    lbAppointments: TLabel;
    lbActiveClientsC: TLabel;
    rCard3: TRectangle;
    lytCardD3: TLayout;
    lbNewAppointments: TLabel;
    lbFullyPaidC: TLabel;
    rCard4: TRectangle;
    lytCardD4: TLayout;
    lbCompleted: TLabel;
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
    lytQuickActions: TLayout;
    lbQuickActions: TLabel;
    Grid1: TGrid;
    lytTwoColumns: TLayout;
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
  if (frmMain.ClientWidth > 1900) OR (frmMain.ClientWidth > 1300) then
  begin
    glytCards.ItemWidth := 320;
    glytCards.Height := 160;
  end
  else if (frmMain.ClientWidth <= 850) AND (frmMain.ClientHeight <= 505) then
  begin
    // Cards
    glytCards.Height := 300;

    // Quick actions
    rUrgentContracts.Width := 280;
    rQuickActions.Width := 215;

    // Button text font size
    btnNewPatient.TextSettings.Font.Size := 12;
    btnNewAppointment.TextSettings.Font.Size := 12;
    btnReportAnIssue.TextSettings.Font.Size := 12;
  end;

  if (frmMain.ClientWidth >= 900) AND (frmMain.ClientHeight >= 505) then
  begin
    // Quick actions
    rUrgentContracts.Width := 205;
    rQuickActions.Width := 280;

    // Button text font size
    btnNewPatient.TextSettings.Font.Size := 14;
    btnNewAppointment.TextSettings.Font.Size := 14;
    btnReportAnIssue.TextSettings.Font.Size := 14;
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
  else if (frmMain.ClientWidth > 900) AND (frmMain.ClientWidth < 1300) then
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
