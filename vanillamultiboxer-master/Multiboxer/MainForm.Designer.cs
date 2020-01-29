namespace Multiboxer
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonStartMultiboxing = new System.Windows.Forms.Button();
            this.tabControlMainWindow = new System.Windows.Forms.TabControl();
            this.tabPageMultiboxing = new System.Windows.Forms.TabPage();
            this.buttonClearConsole = new System.Windows.Forms.Button();
            this.checkBoxLogErrors = new System.Windows.Forms.CheckBox();
            this.checkBoxLogDebugs = new System.Windows.Forms.CheckBox();
            this.checkBoxLogMessages = new System.Windows.Forms.CheckBox();
            this.richTextBoxMainDebugConsole = new System.Windows.Forms.RichTextBox();
            this.buttonMasterClientListHelp = new System.Windows.Forms.Button();
            this.labelSelectMasterClient = new System.Windows.Forms.Label();
            this.buttonRefreshClients = new System.Windows.Forms.Button();
            this.listBoxSelectMasterClient = new System.Windows.Forms.ListBox();
            this.tabPageIgnoreList = new System.Windows.Forms.TabPage();
            this.checkBoxWhitelist = new System.Windows.Forms.CheckBox();
            this.checkBoxBlacklist = new System.Windows.Forms.CheckBox();
            this.checkBoxEnableIgnoreList = new System.Windows.Forms.CheckBox();
            this.buttonSaveIgnoreList = new System.Windows.Forms.Button();
            this.buttonIgnoreListHelp = new System.Windows.Forms.Button();
            this.labelIgnoreList = new System.Windows.Forms.Label();
            this.richTextBoxIgnoreList = new System.Windows.Forms.RichTextBox();
            this.tabPageMacroGenerator = new System.Windows.Forms.TabPage();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.buttonCopyMacroContent = new System.Windows.Forms.Button();
            this.buttonCopyMacroName = new System.Windows.Forms.Button();
            this.textBoxMacroName = new System.Windows.Forms.TextBox();
            this.richTextBoxMacroContent = new System.Windows.Forms.RichTextBox();
            this.listBoxGeneratedMacros = new System.Windows.Forms.ListBox();
            this.listBoxMacroGenCharacterSelect = new System.Windows.Forms.ListBox();
            this.statusStripMainStatus = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabelStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.helpProvider_IgnoreList = new System.Windows.Forms.HelpProvider();
            this.buttonMacroGenHelp = new System.Windows.Forms.Button();
            this.tabControlMainWindow.SuspendLayout();
            this.tabPageMultiboxing.SuspendLayout();
            this.tabPageIgnoreList.SuspendLayout();
            this.tabPageMacroGenerator.SuspendLayout();
            this.statusStripMainStatus.SuspendLayout();
            this.SuspendLayout();
            // 
            // buttonStartMultiboxing
            // 
            this.buttonStartMultiboxing.Location = new System.Drawing.Point(505, 316);
            this.buttonStartMultiboxing.Name = "buttonStartMultiboxing";
            this.buttonStartMultiboxing.Size = new System.Drawing.Size(152, 35);
            this.buttonStartMultiboxing.TabIndex = 0;
            this.buttonStartMultiboxing.Text = "Start Multiboxing";
            this.buttonStartMultiboxing.UseVisualStyleBackColor = true;
            this.buttonStartMultiboxing.Click += new System.EventHandler(this.buttonStartMultiboxing_Click);
            // 
            // tabControlMainWindow
            // 
            this.tabControlMainWindow.Controls.Add(this.tabPageMultiboxing);
            this.tabControlMainWindow.Controls.Add(this.tabPageIgnoreList);
            this.tabControlMainWindow.Controls.Add(this.tabPageMacroGenerator);
            this.tabControlMainWindow.Location = new System.Drawing.Point(-2, 3);
            this.tabControlMainWindow.Name = "tabControlMainWindow";
            this.tabControlMainWindow.SelectedIndex = 0;
            this.tabControlMainWindow.Size = new System.Drawing.Size(677, 401);
            this.tabControlMainWindow.TabIndex = 1;
            // 
            // tabPageMultiboxing
            // 
            this.tabPageMultiboxing.Controls.Add(this.buttonClearConsole);
            this.tabPageMultiboxing.Controls.Add(this.checkBoxLogErrors);
            this.tabPageMultiboxing.Controls.Add(this.checkBoxLogDebugs);
            this.tabPageMultiboxing.Controls.Add(this.checkBoxLogMessages);
            this.tabPageMultiboxing.Controls.Add(this.richTextBoxMainDebugConsole);
            this.tabPageMultiboxing.Controls.Add(this.buttonMasterClientListHelp);
            this.tabPageMultiboxing.Controls.Add(this.labelSelectMasterClient);
            this.tabPageMultiboxing.Controls.Add(this.buttonRefreshClients);
            this.tabPageMultiboxing.Controls.Add(this.listBoxSelectMasterClient);
            this.tabPageMultiboxing.Controls.Add(this.buttonStartMultiboxing);
            this.tabPageMultiboxing.Location = new System.Drawing.Point(4, 22);
            this.tabPageMultiboxing.Name = "tabPageMultiboxing";
            this.tabPageMultiboxing.Padding = new System.Windows.Forms.Padding(3);
            this.tabPageMultiboxing.Size = new System.Drawing.Size(669, 375);
            this.tabPageMultiboxing.TabIndex = 0;
            this.tabPageMultiboxing.Text = "Multiboxing";
            this.tabPageMultiboxing.UseVisualStyleBackColor = true;
            // 
            // buttonClearConsole
            // 
            this.buttonClearConsole.Location = new System.Drawing.Point(183, 316);
            this.buttonClearConsole.Name = "buttonClearConsole";
            this.buttonClearConsole.Size = new System.Drawing.Size(49, 35);
            this.buttonClearConsole.TabIndex = 9;
            this.buttonClearConsole.Text = "Clear";
            this.buttonClearConsole.UseVisualStyleBackColor = true;
            this.buttonClearConsole.Click += new System.EventHandler(this.buttonClearConsole_Click);
            // 
            // checkBoxLogErrors
            // 
            this.checkBoxLogErrors.AutoSize = true;
            this.checkBoxLogErrors.Checked = true;
            this.checkBoxLogErrors.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxLogErrors.Location = new System.Drawing.Point(574, 9);
            this.checkBoxLogErrors.Name = "checkBoxLogErrors";
            this.checkBoxLogErrors.Size = new System.Drawing.Size(83, 19);
            this.checkBoxLogErrors.TabIndex = 8;
            this.checkBoxLogErrors.Text = "Error Logs";
            this.checkBoxLogErrors.UseVisualStyleBackColor = true;
            this.checkBoxLogErrors.CheckedChanged += new System.EventHandler(this.checkBoxLogError_CheckedChanged);
            // 
            // checkBoxLogDebugs
            // 
            this.checkBoxLogDebugs.AutoSize = true;
            this.checkBoxLogDebugs.Checked = true;
            this.checkBoxLogDebugs.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxLogDebugs.Location = new System.Drawing.Point(475, 9);
            this.checkBoxLogDebugs.Name = "checkBoxLogDebugs";
            this.checkBoxLogDebugs.Size = new System.Drawing.Size(93, 19);
            this.checkBoxLogDebugs.TabIndex = 7;
            this.checkBoxLogDebugs.Text = "Debug Logs";
            this.checkBoxLogDebugs.UseVisualStyleBackColor = true;
            this.checkBoxLogDebugs.CheckedChanged += new System.EventHandler(this.checkBoxLogDebug_CheckedChanged);
            // 
            // checkBoxLogMessages
            // 
            this.checkBoxLogMessages.AutoSize = true;
            this.checkBoxLogMessages.Checked = true;
            this.checkBoxLogMessages.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxLogMessages.Location = new System.Drawing.Point(362, 9);
            this.checkBoxLogMessages.Name = "checkBoxLogMessages";
            this.checkBoxLogMessages.Size = new System.Drawing.Size(107, 19);
            this.checkBoxLogMessages.TabIndex = 6;
            this.checkBoxLogMessages.Text = "Message Logs";
            this.checkBoxLogMessages.UseVisualStyleBackColor = true;
            this.checkBoxLogMessages.CheckedChanged += new System.EventHandler(this.checkBoxLogMessages_CheckedChanged);
            // 
            // richTextBoxMainDebugConsole
            // 
            this.richTextBoxMainDebugConsole.Location = new System.Drawing.Point(183, 34);
            this.richTextBoxMainDebugConsole.Name = "richTextBoxMainDebugConsole";
            this.richTextBoxMainDebugConsole.ReadOnly = true;
            this.richTextBoxMainDebugConsole.Size = new System.Drawing.Size(474, 276);
            this.richTextBoxMainDebugConsole.TabIndex = 5;
            this.richTextBoxMainDebugConsole.Text = "";
            // 
            // buttonMasterClientListHelp
            // 
            this.buttonMasterClientListHelp.Location = new System.Drawing.Point(145, 34);
            this.buttonMasterClientListHelp.Name = "buttonMasterClientListHelp";
            this.buttonMasterClientListHelp.Size = new System.Drawing.Size(27, 24);
            this.buttonMasterClientListHelp.TabIndex = 4;
            this.buttonMasterClientListHelp.Text = "?";
            this.buttonMasterClientListHelp.UseVisualStyleBackColor = true;
            this.buttonMasterClientListHelp.Click += new System.EventHandler(this.buttonMasterClientListHelp_Click);
            // 
            // labelSelectMasterClient
            // 
            this.labelSelectMasterClient.AutoSize = true;
            this.labelSelectMasterClient.Location = new System.Drawing.Point(29, 40);
            this.labelSelectMasterClient.Name = "labelSelectMasterClient";
            this.labelSelectMasterClient.Size = new System.Drawing.Size(119, 15);
            this.labelSelectMasterClient.TabIndex = 3;
            this.labelSelectMasterClient.Text = "Select Master Client:";
            // 
            // buttonRefreshClients
            // 
            this.buttonRefreshClients.Location = new System.Drawing.Point(57, 216);
            this.buttonRefreshClients.Name = "buttonRefreshClients";
            this.buttonRefreshClients.Size = new System.Drawing.Size(88, 34);
            this.buttonRefreshClients.TabIndex = 2;
            this.buttonRefreshClients.Text = "Refresh";
            this.buttonRefreshClients.UseVisualStyleBackColor = true;
            this.buttonRefreshClients.Click += new System.EventHandler(this.buttonRefreshClients_Click);
            // 
            // listBoxSelectMasterClient
            // 
            this.listBoxSelectMasterClient.FormattingEnabled = true;
            this.listBoxSelectMasterClient.Location = new System.Drawing.Point(32, 63);
            this.listBoxSelectMasterClient.Name = "listBoxSelectMasterClient";
            this.listBoxSelectMasterClient.Size = new System.Drawing.Size(140, 147);
            this.listBoxSelectMasterClient.TabIndex = 1;
            this.listBoxSelectMasterClient.SelectedIndexChanged += new System.EventHandler(this.listBoxSelectMasterClient_SelectedIndexChanged);
            // 
            // tabPageIgnoreList
            // 
            this.tabPageIgnoreList.Controls.Add(this.checkBoxWhitelist);
            this.tabPageIgnoreList.Controls.Add(this.checkBoxBlacklist);
            this.tabPageIgnoreList.Controls.Add(this.checkBoxEnableIgnoreList);
            this.tabPageIgnoreList.Controls.Add(this.buttonSaveIgnoreList);
            this.tabPageIgnoreList.Controls.Add(this.buttonIgnoreListHelp);
            this.tabPageIgnoreList.Controls.Add(this.labelIgnoreList);
            this.tabPageIgnoreList.Controls.Add(this.richTextBoxIgnoreList);
            this.tabPageIgnoreList.Location = new System.Drawing.Point(4, 22);
            this.tabPageIgnoreList.Name = "tabPageIgnoreList";
            this.tabPageIgnoreList.Padding = new System.Windows.Forms.Padding(3);
            this.tabPageIgnoreList.Size = new System.Drawing.Size(669, 375);
            this.tabPageIgnoreList.TabIndex = 1;
            this.tabPageIgnoreList.Text = "Ignore List";
            this.tabPageIgnoreList.UseVisualStyleBackColor = true;
            // 
            // checkBoxWhitelist
            // 
            this.checkBoxWhitelist.AutoSize = true;
            this.checkBoxWhitelist.Location = new System.Drawing.Point(376, 97);
            this.checkBoxWhitelist.Name = "checkBoxWhitelist";
            this.checkBoxWhitelist.Size = new System.Drawing.Size(132, 19);
            this.checkBoxWhitelist.TabIndex = 6;
            this.checkBoxWhitelist.Text = "Whitelist these keys";
            this.checkBoxWhitelist.UseVisualStyleBackColor = true;
            this.checkBoxWhitelist.CheckedChanged += new System.EventHandler(this.checkBoxWhitelist_CheckedChanged);
            // 
            // checkBoxBlacklist
            // 
            this.checkBoxBlacklist.AutoSize = true;
            this.checkBoxBlacklist.Checked = true;
            this.checkBoxBlacklist.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxBlacklist.Location = new System.Drawing.Point(376, 72);
            this.checkBoxBlacklist.Name = "checkBoxBlacklist";
            this.checkBoxBlacklist.Size = new System.Drawing.Size(131, 19);
            this.checkBoxBlacklist.TabIndex = 5;
            this.checkBoxBlacklist.Text = "Blacklist these keys";
            this.checkBoxBlacklist.UseVisualStyleBackColor = true;
            this.checkBoxBlacklist.CheckedChanged += new System.EventHandler(this.checkBoxBlacklist_CheckedChanged);
            // 
            // checkBoxEnableIgnoreList
            // 
            this.checkBoxEnableIgnoreList.AutoSize = true;
            this.checkBoxEnableIgnoreList.Checked = true;
            this.checkBoxEnableIgnoreList.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxEnableIgnoreList.Location = new System.Drawing.Point(376, 47);
            this.checkBoxEnableIgnoreList.Name = "checkBoxEnableIgnoreList";
            this.checkBoxEnableIgnoreList.Size = new System.Drawing.Size(122, 19);
            this.checkBoxEnableIgnoreList.TabIndex = 4;
            this.checkBoxEnableIgnoreList.Text = "Enable IgnoreList";
            this.checkBoxEnableIgnoreList.UseVisualStyleBackColor = true;
            this.checkBoxEnableIgnoreList.CheckedChanged += new System.EventHandler(this.checkBoxEnableIgnoreList_CheckedChanged);
            // 
            // buttonSaveIgnoreList
            // 
            this.buttonSaveIgnoreList.Location = new System.Drawing.Point(295, 17);
            this.buttonSaveIgnoreList.Name = "buttonSaveIgnoreList";
            this.buttonSaveIgnoreList.Size = new System.Drawing.Size(75, 24);
            this.buttonSaveIgnoreList.TabIndex = 3;
            this.buttonSaveIgnoreList.Text = "Save";
            this.buttonSaveIgnoreList.UseVisualStyleBackColor = true;
            this.buttonSaveIgnoreList.Click += new System.EventHandler(this.buttonSaveIgnoreList_Click);
            // 
            // buttonIgnoreListHelp
            // 
            this.buttonIgnoreListHelp.Location = new System.Drawing.Point(214, 17);
            this.buttonIgnoreListHelp.Name = "buttonIgnoreListHelp";
            this.buttonIgnoreListHelp.Size = new System.Drawing.Size(27, 24);
            this.buttonIgnoreListHelp.TabIndex = 2;
            this.buttonIgnoreListHelp.Text = "?";
            this.buttonIgnoreListHelp.UseVisualStyleBackColor = true;
            this.buttonIgnoreListHelp.Click += new System.EventHandler(this.buttonIgnoreListHelp_Click);
            // 
            // labelIgnoreList
            // 
            this.labelIgnoreList.AutoSize = true;
            this.labelIgnoreList.Location = new System.Drawing.Point(144, 20);
            this.labelIgnoreList.Name = "labelIgnoreList";
            this.labelIgnoreList.Size = new System.Drawing.Size(64, 15);
            this.labelIgnoreList.TabIndex = 1;
            this.labelIgnoreList.Text = "Ignore List";
            // 
            // richTextBoxIgnoreList
            // 
            this.richTextBoxIgnoreList.Location = new System.Drawing.Point(10, 47);
            this.richTextBoxIgnoreList.Name = "richTextBoxIgnoreList";
            this.richTextBoxIgnoreList.Size = new System.Drawing.Size(360, 263);
            this.richTextBoxIgnoreList.TabIndex = 0;
            this.richTextBoxIgnoreList.Text = "";
            // 
            // tabPageMacroGenerator
            // 
            this.tabPageMacroGenerator.Controls.Add(this.buttonMacroGenHelp);
            this.tabPageMacroGenerator.Controls.Add(this.label3);
            this.tabPageMacroGenerator.Controls.Add(this.label2);
            this.tabPageMacroGenerator.Controls.Add(this.label1);
            this.tabPageMacroGenerator.Controls.Add(this.buttonCopyMacroContent);
            this.tabPageMacroGenerator.Controls.Add(this.buttonCopyMacroName);
            this.tabPageMacroGenerator.Controls.Add(this.textBoxMacroName);
            this.tabPageMacroGenerator.Controls.Add(this.richTextBoxMacroContent);
            this.tabPageMacroGenerator.Controls.Add(this.listBoxGeneratedMacros);
            this.tabPageMacroGenerator.Controls.Add(this.listBoxMacroGenCharacterSelect);
            this.tabPageMacroGenerator.Location = new System.Drawing.Point(4, 22);
            this.tabPageMacroGenerator.Name = "tabPageMacroGenerator";
            this.tabPageMacroGenerator.Padding = new System.Windows.Forms.Padding(3);
            this.tabPageMacroGenerator.Size = new System.Drawing.Size(669, 375);
            this.tabPageMacroGenerator.TabIndex = 2;
            this.tabPageMacroGenerator.Text = "Macro Generator";
            this.tabPageMacroGenerator.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(489, 12);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(93, 15);
            this.label3.TabIndex = 9;
            this.label3.Text = "Selected Macro";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(306, 12);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(48, 15);
            this.label2.TabIndex = 8;
            this.label2.Text = "Macros";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(97, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(66, 15);
            this.label1.TabIndex = 7;
            this.label1.Text = "Characters";
            // 
            // buttonCopyMacroContent
            // 
            this.buttonCopyMacroContent.Location = new System.Drawing.Point(552, 313);
            this.buttonCopyMacroContent.Name = "buttonCopyMacroContent";
            this.buttonCopyMacroContent.Size = new System.Drawing.Size(105, 45);
            this.buttonCopyMacroContent.TabIndex = 6;
            this.buttonCopyMacroContent.Text = "Copy Content";
            this.buttonCopyMacroContent.UseVisualStyleBackColor = true;
            this.buttonCopyMacroContent.Click += new System.EventHandler(this.buttonCopyMacroContent_Click);
            // 
            // buttonCopyMacroName
            // 
            this.buttonCopyMacroName.Location = new System.Drawing.Point(407, 312);
            this.buttonCopyMacroName.Name = "buttonCopyMacroName";
            this.buttonCopyMacroName.Size = new System.Drawing.Size(105, 45);
            this.buttonCopyMacroName.TabIndex = 5;
            this.buttonCopyMacroName.Text = "Copy Name";
            this.buttonCopyMacroName.UseVisualStyleBackColor = true;
            this.buttonCopyMacroName.Click += new System.EventHandler(this.buttonCopyMacroName_Click);
            // 
            // textBoxMacroName
            // 
            this.textBoxMacroName.Location = new System.Drawing.Point(407, 30);
            this.textBoxMacroName.Name = "textBoxMacroName";
            this.textBoxMacroName.Size = new System.Drawing.Size(250, 20);
            this.textBoxMacroName.TabIndex = 4;
            // 
            // richTextBoxMacroContent
            // 
            this.richTextBoxMacroContent.Location = new System.Drawing.Point(407, 56);
            this.richTextBoxMacroContent.Name = "richTextBoxMacroContent";
            this.richTextBoxMacroContent.Size = new System.Drawing.Size(250, 250);
            this.richTextBoxMacroContent.TabIndex = 3;
            this.richTextBoxMacroContent.Text = "";
            // 
            // listBoxGeneratedMacros
            // 
            this.listBoxGeneratedMacros.FormattingEnabled = true;
            this.listBoxGeneratedMacros.Location = new System.Drawing.Point(260, 30);
            this.listBoxGeneratedMacros.Name = "listBoxGeneratedMacros";
            this.listBoxGeneratedMacros.Size = new System.Drawing.Size(136, 329);
            this.listBoxGeneratedMacros.TabIndex = 2;
            this.listBoxGeneratedMacros.SelectedIndexChanged += new System.EventHandler(this.listBoxGeneratedMacros_SelectedIndexChanged);
            // 
            // listBoxMacroGenCharacterSelect
            // 
            this.listBoxMacroGenCharacterSelect.FormattingEnabled = true;
            this.listBoxMacroGenCharacterSelect.Location = new System.Drawing.Point(23, 30);
            this.listBoxMacroGenCharacterSelect.Name = "listBoxMacroGenCharacterSelect";
            this.listBoxMacroGenCharacterSelect.Size = new System.Drawing.Size(213, 329);
            this.listBoxMacroGenCharacterSelect.TabIndex = 0;
            this.listBoxMacroGenCharacterSelect.SelectedIndexChanged += new System.EventHandler(this.listBoxMacroGenCharacterSelect_SelectedIndexChanged);
            // 
            // statusStripMainStatus
            // 
            this.statusStripMainStatus.ImageScalingSize = new System.Drawing.Size(18, 18);
            this.statusStripMainStatus.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabelStatus});
            this.statusStripMainStatus.Location = new System.Drawing.Point(0, 401);
            this.statusStripMainStatus.Name = "statusStripMainStatus";
            this.statusStripMainStatus.Size = new System.Drawing.Size(671, 24);
            this.statusStripMainStatus.TabIndex = 3;
            // 
            // toolStripStatusLabelStatus
            // 
            this.toolStripStatusLabelStatus.Name = "toolStripStatusLabelStatus";
            this.toolStripStatusLabelStatus.Size = new System.Drawing.Size(18, 19);
            this.toolStripStatusLabelStatus.Text = "...";
            // 
            // buttonMacroGenHelp
            // 
            this.buttonMacroGenHelp.Location = new System.Drawing.Point(519, 323);
            this.buttonMacroGenHelp.Name = "buttonMacroGenHelp";
            this.buttonMacroGenHelp.Size = new System.Drawing.Size(27, 24);
            this.buttonMacroGenHelp.TabIndex = 10;
            this.buttonMacroGenHelp.Text = "?";
            this.buttonMacroGenHelp.UseVisualStyleBackColor = true;
            this.buttonMacroGenHelp.Click += new System.EventHandler(this.buttonMacroGenHelp_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(671, 425);
            this.Controls.Add(this.statusStripMainStatus);
            this.Controls.Add(this.tabControlMainWindow);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "MainForm";
            this.Text = "Multiboxer";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.tabControlMainWindow.ResumeLayout(false);
            this.tabPageMultiboxing.ResumeLayout(false);
            this.tabPageMultiboxing.PerformLayout();
            this.tabPageIgnoreList.ResumeLayout(false);
            this.tabPageIgnoreList.PerformLayout();
            this.tabPageMacroGenerator.ResumeLayout(false);
            this.tabPageMacroGenerator.PerformLayout();
            this.statusStripMainStatus.ResumeLayout(false);
            this.statusStripMainStatus.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonStartMultiboxing;
        private System.Windows.Forms.TabControl tabControlMainWindow;
        private System.Windows.Forms.TabPage tabPageMultiboxing;
        private System.Windows.Forms.TabPage tabPageIgnoreList;
        private System.Windows.Forms.ListBox listBoxSelectMasterClient;
        private System.Windows.Forms.Button buttonRefreshClients;
        private System.Windows.Forms.Label labelIgnoreList;
        private System.Windows.Forms.RichTextBox richTextBoxIgnoreList;
        private System.Windows.Forms.HelpProvider helpProvider_IgnoreList;
        private System.Windows.Forms.Button buttonIgnoreListHelp;
        private System.Windows.Forms.Button buttonSaveIgnoreList;
        private System.Windows.Forms.StatusStrip statusStripMainStatus;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabelStatus;
        private System.Windows.Forms.Label labelSelectMasterClient;
        private System.Windows.Forms.Button buttonMasterClientListHelp;
        private System.Windows.Forms.RichTextBox richTextBoxMainDebugConsole;
        private System.Windows.Forms.CheckBox checkBoxLogErrors;
        private System.Windows.Forms.CheckBox checkBoxLogDebugs;
        private System.Windows.Forms.CheckBox checkBoxLogMessages;
        private System.Windows.Forms.CheckBox checkBoxBlacklist;
        private System.Windows.Forms.CheckBox checkBoxEnableIgnoreList;
        private System.Windows.Forms.CheckBox checkBoxWhitelist;
        private System.Windows.Forms.Button buttonClearConsole;
        private System.Windows.Forms.TabPage tabPageMacroGenerator;
        private System.Windows.Forms.ListBox listBoxMacroGenCharacterSelect;
        private System.Windows.Forms.TextBox textBoxMacroName;
        private System.Windows.Forms.RichTextBox richTextBoxMacroContent;
        private System.Windows.Forms.ListBox listBoxGeneratedMacros;
        private System.Windows.Forms.Button buttonCopyMacroContent;
        private System.Windows.Forms.Button buttonCopyMacroName;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button buttonMacroGenHelp;
    }
}

