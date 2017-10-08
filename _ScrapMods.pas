{
	Script description.
	------------------------
	Hotkey: Alt+Shift+A
}

unit userscript;

    const
        scriptVersion = '1.0';

    var
        slMasters, slPlugins : TStringList;
        plugin, master : IInterface;

        i, mastersLastIndex, pluginsLastIndex : Integer;

        bRunScript, bWeapons, bArmors, bOverwrite, bVerbose, bDebug : boolean;

        frm : TForm;
        lblMasters, lblPlugins, lblVersion : TLabel;
        cmbMasters, cmbPlugins : TComboBox;
        cbWeapons, cbArmors, cbOverwrite, cbVerbose, bVerbosPrevious: TCheckBox;
        btnOk, btnCancel : TButtom;

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    begin
        if Key = VK_RETURN then begin
            TForm(Sender).ModalResult := mrOK;
        end;

        if Key = VK_ESCAPE then begin
            TForm(Sender).ModalResult := mrCancel;
        end;
    end;

    procedure frmFormClose(Sender: TObject; var Action: TCloseAction);
    begin
        if frm.ModalResult <> mrOk then Exit;
        bRunScript := true;
    end;

    procedure cmbMastersOnExit(Sender: TObject);
    var
        sFilename : string;
        sFile : IInterface;
    begin
        if cmbMasters.ItemIndex = -1 then begin
            cmbMasters.ItemIndex := mastersLastIndex;
        end;
        if cmbMasters.Text <> cmbMasters.Items[cmbMasters.ItemIndex] then begin
            cmbMasters.Text := cmbMasters.Items[cmbMasters.ItemIndex];
        end;

        mastersLastIndex := cmbMasters.ItemIndex;
        master := getFile1(cmbMasters.Text);
    end;

    procedure cmbPluginsOnExit(Sender: TObject);
    begin
        if cmbPlugins.ItemIndex = -1 then begin
            cmbPlugins.ItemIndex := pluginsLastIndex;
        end;
        if cmbPlugins.Text <> cmbPlugins.Items[cmbPlugins.ItemIndex] then begin
            cmbPlugins.Text := cmbPlugins.Items[cmbPlugins.ItemIndex];
        end;

        pluginsLastIndex := cmbPlugins.ItemIndex;
        plugin := getFile1(cmbPlugins.Text);

    end;

    procedure cbWeaponsOnClick(Sender: TObject);
    begin
        bWeapons := cbWeapons.State;
    end;

    procedure cbArmorsOnClick(Sender: TObject);
    begin
        bArmors := cbArmors.State;
    end;

    procedure cbOverwriteOnClick(Sender: TObject);
    begin
        bOverwrite := cbOverwrite.State;
    end;

    procedure cbVerboseOnClick(Sender: TObject);
    begin
        bVerbose := cbVerbose.State;
    end;

    procedure lblVersionOnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    begin
        if Button = mbRight then begin
            // AddMessage('Richt-Click');
            // if Shift = [ssLeft, ssCtrl, ssDouble] then begin
                // if (ssDouble in Shift) then begin
                    bDebug := not bDebug;
                    if bDebug then begin
                      AddMessage('DEBUG ON');
                      cbVerbose.Enabled := false;
                      bVerbosPrevious := cbVerbose.State;
                      cbVerbose.State := true;
                    end else begin
                      AddMessage('DEBUG OFF');
                      cbVerbose.Enabled := true;
                      cbVerbose.State := bVerbosPrevious;
                    end;
                // end;
            // end;
        end;
    end;

    function getFile1(filename : string) : IInterface;
    var
        sFilename : string;
        sFile : IInterface;
    begin
        Result := nil;
        for i := 0 to FileCount - 1 do begin
            sFile := FileByIndex(i);
            sFilename := GetFileName(sFile);

            if SameText(filename, sFilename) then begin
              Result := sFile;
              break;
            end;
        end;
    end;

    procedure ShowForm;
    var
        i: integer;
    begin
        frm := TForm.Create(nil);
        try
            frm.BorderStyle := bsDialog;
            frm.Caption := wbGameName + ' Scrap Mods ' + scriptVersion;
            frm.Width := 320;
            frm.Height := 230;
            frm.Position := poScreenCenter;
            frm.KeyPreview := True;
            frm.OnKeyDown := FormKeyDown;
            frm.OnClose := frmFormClose;

            lblMasters := TLabel.Create(frm);
            lblMasters.Parent := frm;
            lblMasters.Caption := 'Master:';
            lblMasters.Top := 20;
            lblMasters.Left := 16;
            lblMasters.Width := 35;

            cmbMasters := TComboBox.Create(frm);
            cmbMasters.Parent := frm;
            cmbMasters.Top := lblMasters.Top - 4;
            cmbMasters.Left := lblMasters.Left + lblMasters.Width + 16;
            cmbMasters.Width := 200;
            cmbMasters.AutoDropDown := true;
            cmbMasters.OnExit := cmbMastersOnExit;
            for i := 0 to Pred(slMasters.Count) do begin
                cmbMasters.Items.Add(slMasters[i])
            end;
            cmbMasters.ItemIndex := mastersLastIndex;

            lblPlugins := TLabel.Create(frm);
            lblPlugins.Parent := frm;
            lblPlugins.Caption := 'Plugin:';
            lblPlugins.Top := cmbMasters.Top + cmbMasters.Height + 20;
            lblPlugins.Left := lblMasters.Left;
            lblPlugins.Width := lblMasters.Width;

            cmbPlugins := TComboBox.Create(frm);
            cmbPlugins.Parent := frm;
            cmbPlugins.Top := lblPlugins.Top - 4;
            cmbPlugins.Left := lblPlugins.Left + lblPlugins.Width + 16;
            cmbPlugins.Width := 200;
            cmbPlugins.AutoDropDown := true;
            cmbPlugins.OnExit := cmbPluginsOnExit;
            for i := 0 to Pred(slPlugins.Count) do begin
                cmbPlugins.Items.Add(slPlugins[i])
            end;
            cmbPlugins.ItemIndex := pluginsLastIndex;

            cbWeapons := TCheckBox.Create(frm);
            cbWeapons.parent := frm;
            cbWeapons.Caption := '&Weapons';
            cbWeapons.Top := lblPlugins.Top + lblPlugins.Height + 16;
            cbWeapons.Left := lblMasters.Left;
            cbWeapons.OnClick := cbWeaponsOnClick;
            cbWeapons.State := bWeapons;
            
            cbArmors := TCheckBox.Create(frm);
            cbArmors.parent := frm;
            cbArmors.Caption := '&Armors';
            cbArmors.Top := cbWeapons.Top + cbWeapons.Height + 8;
            cbArmors.Left := lblMasters.Left;
            cbArmors.OnClick := cbArmorsOnClick;
            cbArmors.State := bArmors;

            cbOverwrite := TCheckBox.Create(frm);
            cbOverwrite.parent := frm;
            cbOverwrite.Caption := 'Overw&rite';
            cbOverwrite.Top := cbWeapons.Top;
            cbOverwrite.Left := cbWeapons.Left + cbWeapons.Width + 16;
            cbOverwrite.OnClick := cbOverwriteOnClick;
            cbOverwrite.State := bOverwrite;

            cbVerbose := TCheckBox.Create(frm);
            cbVerbose.parent := frm;
            cbVerbose.Caption := '&Verbose';
            cbVerbose.Top := cbWeapons.Top + cbWeapons.Height + 8;
            cbVerbose.Left := cbWeapons.Left + cbWeapons.Width + 16;
            cbVerbose.OnClick := cbVerboseOnClick;
            cbVerbose.State := bVerbose;

            btnOk := TButton.Create(frm);
            btnOk.Parent := frm;
            btnOk.Caption := '&OK';
            btnOk.Top := cbVerbose.Top + cbVerbose.Height + 20;
            btnOk.Width := 100;
            btnOk.Left := Floor((frm.Width - (2 * btnOk.Width)) / 2) - 12;
            btnOk.ModalResult := mrOk;

            btnCancel := TButton.Create(frm);
            btnCancel.Parent := frm;
            btnCancel.Caption := '&Cancel';
            btnCancel.Top := btnOk.Top;
            btnCancel.Width := btnOk.Width;
            btnCancel.Left := frm.Width - btnCancel.Width - btnOk.Left - 12;
            btnCancel.ModalResult := mrCancel;

            lblVersion := TLabel.Create(frm);
            lblVersion.Parent := frm;
            lblVersion.Caption := 'Version ' + scriptVersion;
            lblVersion.Width := 60;
            lblVersion.Top := frm.Height - lblVersion.Height - 35;
            lblVersion.Left := frm.Width - lblVersion.Width - 7;
            lblVersion.OnMouseDown := lblVersionOnMouseDown;

            frm.ShowModal;

        finally
            frm.Free;
        end;
    end;

    function Initialize: integer;
    var
        sFilename : string;
        sFile : IInterface;
    begin
        slMasters := TStringList.Create;
        slPlugins := TStringList.Create;

        mastersLastIndex := 0;
        pluginsLastIndex := 0;
        
        bWeapons := true;
        bArmors := true;
        bOverwrite := false;
        bVerbose := false;
        bVerbosPrevious := false;
        bDebug := false;

        bRunScript := false;

        for i := 0 to FileCount - 1 do begin
            sFile := FileByIndex(i);
            sFilename := GetFileName(sFile);

            if SameText(sFilename, 'Fallout3.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat') then begin
              continue;
            end;

            if SameText(sFilename, 'FalloutNV.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat') then begin
              continue;
            end;

            if SameText(sFilename, 'Fallout4.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat') then begin
              continue;
            end;

            if SameText(sFilename, 'Oblivion.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat') then begin
              continue;
            end;

            if SameText(sFilename, 'Skyrim.Hardcoded.keep.this.with.the.exe.and.otherwise.ignore.it.I.really.mean.it.dat') then begin
              continue;
            end;

            if GetIsESM(sFile) then begin
                slMasters.Add(sFilename);
            end;

            if not GetIsESM(sFile) then begin
                slPlugins.Add(sFilename);
            end;
        end;

        master := getFile1(slMasters[0]);
        plugin := getFile1(slPlugins[0]);

        ShowForm;

        if bRunScript then begin
          runScript;
        end;
    end;

    procedure runScript;
    var
        j, debugCounter: integer;
        masterCOBJ, pluginCOBJ : IInterface;
        element, elementOMOD, elementMISC, elementCOBJ : IInterface;
        components, componentsNew, component, componentNew : IInterface;

    begin
        ClearMessages();

        AddMessage(' ');
        AddMessage('--------------------------------------------------------------------------------');
        AddMessage('Add components to mods');
        AddMessage('--------------------------------------------------------------------------------');
        AddMessage(' ');

        AddMessage('Master: ' + GetFileName(master));
        AddMessage('Plugin: ' + GetFileName(plugin));
        AddMessage(' ');
        

        masterCOBJ := GroupBySignature(master, 'COBJ');
        pluginCOBJ := GroupBySignature(plugin, 'COBJ');
        if bDebug then begin
            AddMessage('[DEBUG] {0} Master Top Group COBJ: ' + FullPath(masterCOBJ));
            AddMessage('[DEBUG] {0} Plugin Top Group COBJ: ' + FullPath(pluginCOBJ));
            AddMessage(' ');
        end;

        for i := 0 to Pred(ElementCount(masterCOBJ)) do begin
            elementCOBJ := ElementByIndex(masterCOBJ, i);
            if bDebug then begin
                AddMessage('[DEBUG] {1} elementCOBJ: ' + FullPath(elementCOBJ));
            end;

            elementOMOD := LinksTo(ElementByPath(elementCOBJ, 'CNAM'));
            if bDebug then begin
                AddMessage('[DEBUG] {2} elementOMOD: ' + FullPath(elementOMOD));
            end;

            if Not Assigned(elementOMOD) then begin
                if bVerbose then begin
                    AddMessage('Skip ' +  ShortName(elementCOBJ) + ' [no created object]');
                end;
                if bDebug then begin
                    AddMessage(' ');
                end;
                continue;
            end;

            if Signature(elementOMOD) <> 'OMOD' then begin
                if bVerbose then begin
                    AddMessage('Skip ' +  ShortName(elementCOBJ) + ' [no object modification]');
                end;
                if bDebug then begin
                    AddMessage(' ');
                end;
                continue;
            end;

            if bDebug then begin
                AddMessage('[DEBUG] {3} elementOMOD Form Type: ' + GetEditValue(ElementByPath(elementOMOD, 'DATA\Form Type')));
            end;
            if not bWeapons then begin
                if GetEditValue(ElementByPath(elementOMOD, 'DATA\Form Type')) = 'Weapon' then begin
                    if bVerbose then begin
                        AddMessage('Skip ' +  ShortName(elementCOBJ) + ' [no weapon import]');
                    end;
                    if bDebug then begin
                        AddMessage(' ');
                    end;
                    continue;
                end;
            end;
            
            if not bArmors then begin
                if GetEditValue(ElementByPath(elementOMOD, 'DATA\Form Type')) = 'Armor' then begin
                    if bVerbose then begin
                        AddMessage('Skip ' +  ShortName(elementCOBJ) + ' [no armor import]');
                    end;
                    if bDebug then begin
                        AddMessage(' ');
                    end;
                    continue;
                end;
            end;
            
            if GetEditValue(ElementByPath(elementOMOD, 'DATA\Form Type')) <> 'Weapon' then begin
                if GetEditValue(ElementByPath(elementOMOD, 'DATA\Form Type')) <> 'Armor' then begin
                    if bVerbose then begin
                        AddMessage('Skip ' +  ShortName(elementCOBJ) + ' [unknown form type import]');
                    end;
                    if bDebug then begin
                        AddMessage(' ');
                    end;
                    continue;
                end;
            end;

            elementMISC := LinksTo(ElementByPath(elementOMOD, 'LNAM'));
            if bDebug then begin
                AddMessage('[DEBUG] {4} elementMISC: ' + FullPath(elementMISC));
            end;

            if Not Assigned(elementMISC) then begin
                if bVerbose then begin
                    AddMessage('Skip ' + ShortName(elementOMOD) + ' [no loose modification]');
                end;
                if bDebug then begin
                    AddMessage(' ');
                end;
                continue;
            end;

            element := RecordByFormID(plugin, FixedFormID(elementMISC), false);
            if bDebug then begin
                AddMessage('[DEBUG] {5} element: ' + FullPath(element));
            end;

            components := ElementByPath(elementCOBJ, 'FVPA');
            if bDebug then begin
                AddMessage('[DEBUG] {6} elementCOBJ components: ' + FullPath(components));
                AddMessage('[DEBUG] {6} elementCOBJ components count: ' + IntToStr(ElementCount(components)));
            end;

            if not Assigned(components) then begin
                if bVerbose then begin
                    AddMessage('Skip ' + ShortName(elementOMOD) + ' [no components]');
                end;
                if bDebug then begin
                    AddMessage(' ');
                end;
                continue;
            end;

            if Assigned(components) then begin
                if ElementCount(components) = 0 then begin
                    if bVerbose then begin
                        AddMessage('Skip ' + ShortName(elementOMOD) + ' [no components]');
                    end;
                    if bDebug then begin
                        AddMessage(' ');
                    end;
                    continue;
                end;
            end;

            componentsNew := ElementByPath(element, 'CVPA');
            if bDebug then begin
                AddMessage('[DEBUG] {7} element components: ' + FullPath(componentsNew));
                AddMessage('[DEBUG] {7} element components count: ' + IntToStr(ElementCount(componentsNew)));
            end;

            if not bOverwrite then begin
                if Assigned(componentsNew) then begin
                    if ElementCount(componentsNew) > 0 then begin
                        if bVerbose then begin
                            AddMessage('Skip ' + ShortName(elementOMOD) + ' [no overwrite]');
                        end;
                        if bDebug then begin
                            AddMessage(' ');
                        end;
                        continue;
                    end;
                end;
            end;
            
            AddMessage('Change ' + ShortName(elementMISC));

            if not Assigned(element) then begin
                AddMessage('    Add to plugin');
                element := wbCopyElementToFile(elementMISC, plugin, false, true);
                if not Assigned(element) then begin
                    // MessageBeep(MB_ICONHAND);
                    AddMessage('[ERROR] Can''t copy base record as new');
                    AddMessage(' ');
                    continue;
                end;
            end;

            if FullPath(element) = FullPath(elementMISC) then begin
                AddMessage('    Add to plugin');
                element := wbCopyElementToFile(elementMISC, plugin, false, true);
                if not Assigned(element) then begin
                    // MessageBeep(MB_ICONHAND);
                    AddMessage('[ERROR] Can''t copy base record as new');
                    AddMessage(' ');
                    continue;
                end;
            end;

            if bOverwrite then begin
                if Assigned(componentsNew) then begin
                    if ElementCount(componentsNew) > 0 then begin
                        AddMessage('    Remove existing components');
                        for j := 0 to Pred(ElementCount(componentsNew)) do begin
                            component := ElementByIndex(componentsNew, j);
                            Remove(component);
                        end;
                    end;
                end;
            end;

            if not Assigned(componentsNew) then begin
                AddMessage('    Add CVPA container');
                componentsNew := Add(element, 'CVPA', false);
                if not Assigned(componentsNew) then begin
                    // MessageBeep(MB_ICONHAND);
                    AddMessage('[ERROR] Can''t create CVPA container');
                    AddMessage(' ');
                    continue;
                end;
                Remove(ElementByIndex(componentsNew, 0));
            end;

            for j := 0 to Pred(ElementCount(components)) do begin
                component := ElementByIndex(components, j);
                componentNew := ElementAssign(componentsNew, HighInteger, nil, False);

                AddMessage('    Add component: ' + GetElementEditValues(component, 'Count') + ' x ' + GetElementEditValues(component, 'Component'));

                SetElementEditValues(componentNew, 'Component', GetElementEditValues(component, 'Component'));
                SetElementEditValues(componentNew, 'Count', GetElementEditValues(component, 'Count'));

                if bDebug then begin
                    AddMessage('[DEBUG] {8} elementCOBJ component[:' + IntToStr(j) + ']: ' + FullPath(component));
                    AddMessage('[DEBUG] {8} elementCOBJ component[' + IntToStr(j) + '] value: ' + GetElementEditValues(component, 'Component'));
                    AddMessage('[DEBUG] {8} elementCOBJ component[:' + IntToStr(j) + '] count: ' + GetElementEditValues(component, 'Count'));
                    AddMessage('[DEBUG] {8} element component[:' + IntToStr(j) + ']: ' + FullPath(componentNew));
                    AddMessage('[DEBUG] {8} element component[:' + IntToStr(j) + '] value: ' + GetElementEditValues(ElementByPath(componentNew, 'Component')));
                    AddMessage('[DEBUG] {8} element component[:' + IntToStr(j) + '] count: ' + GetElementEditValues(ElementByPath(componentNew, 'Count')));
                end;
            end;
            AddMessage(' ');
        end;
    end;

end.
