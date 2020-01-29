using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Gma.System.MouseKeyHook;

namespace Multiboxer
{
    public partial class MainForm : Form
    {
        // fields
        bool isListening = false; // is the program listening for input?

        private Dictionary<string, string> _masterMacroList;
        private Dictionary<string, string> _childMacroList;

        // class instances
        private InputCallback input;
        private ConfigurationManager config;
        private ConfigurationManager.ConsoleWriter consoleWriterMain;

        /* TODO NEXT *
         * Find out a way to make DebugLog and UpdateStatus linked  (DONE)
         * Find out a way to make DebugLog instance accessible from all classes (SEMI-DONE) (P3)
         * Make Master Client selector show the character name (read memory) (DONE)
         * Create a hotkey for starting/stopping multiboxing that is customizable (P1)
         * Add more/better UI elements such as tab control for settings (P2)
         * Test out hotkey creator that can send commands to window such as: (P3)
         * <Press Enter><Type "/script AcceptGroup"> etc. and possibly look at creating an addon for simpler macros, such as "/mb p a" for accepting group
         * Figure out how to send complex keystrokes to windows, such as shift-4 (DONE)
         * Re-make blacklist with better options and pressing keys to add instead of manually typing out names (P2)
         * Blacklist options: (P1)
         * Blacklist profiles, ability to enable/disable profiles, ability to create whitelist instead of blacklist
         * Mouse broadcasting? (P4) */

        #region Initialization
        public MainForm()
        {
            InitializeComponent();
        }
        // Event Handlers

        private void MainForm_Load(object sender, EventArgs e)
        {
            // Init input callbacks and config manager
            InitializeClasses();

            if (!config.IsFirstRun())
            {
                config.LoadFromConfig(richTextBoxIgnoreList); // load into ignore list from cfg
                InputCallback.ProcManager.SetIgnoredKeys(richTextBoxIgnoreList); // save ignore list
            }

            Console.SetOut(consoleWriterMain); // route console output to debug window

            // Check for running wow procs and populate the GUI list

            InputCallback.ProcManager.RefreshClientProcList();

            PopulateClientList();
            PopulateCharacterList();

            config.UpdateStatus($"Found {InputCallback.ProcManager.GameProcList.Length} process(es).", ConfigurationManager.LogType.MESSAGE);
        }

        private void InitializeClasses()
        {
            _masterMacroList = new Dictionary<string, string>();
            _childMacroList = new Dictionary<string, string>();

            // Init input callbacks and config manager
            input = new InputCallback();
            config = new ConfigurationManager("config.cfg", toolStripStatusLabelStatus);
            consoleWriterMain = new ConfigurationManager.ConsoleWriter(richTextBoxMainDebugConsole, "logs", checkBoxLogMessages.Checked, checkBoxLogDebugs.Checked, checkBoxLogErrors.Checked);

            InputCallback.ProcManager.SetConsoleWriter(consoleWriterMain); // allow procManager to write to console
            config.SetConsoleWriter(consoleWriterMain);
            WindowUtil.SetConsoleWriter(consoleWriterMain);
        }
        #endregion Initialization

        #region MULTIBOXING TAB

        #region Main Console Event Handlers
        private void checkBoxLogMessages_CheckedChanged(object sender, EventArgs e) => consoleWriterMain.LogMessages = checkBoxLogMessages.Checked;

        private void checkBoxLogDebug_CheckedChanged(object sender, EventArgs e) => consoleWriterMain.LogDebugs = checkBoxLogDebugs.Checked;

        private void checkBoxLogError_CheckedChanged(object sender, EventArgs e) => consoleWriterMain.LogErrors = checkBoxLogErrors.Checked;

        private void buttonClearConsole_Click(object sender, EventArgs e) => richTextBoxMainDebugConsole.Clear();
        #endregion Main Console Event Handlers

        private void buttonStartMultiboxing_Click(object sender, EventArgs e)
        {
            StartStopMultiboxing();
        }

        private void listBoxSelectMasterClient_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (listBoxSelectMasterClient.SelectedItem != null) // avoid unecessary exceptions
                {
                    string procDataUnformatted = listBoxSelectMasterClient.SelectedItem.ToString();

                    string procDataFormatted = procDataUnformatted.Replace(" ", "");

                    string[] procData = procDataFormatted.Split('-');

                    InputCallback.ProcManager.SetMasterClient(Convert.ToInt32(procData[1]));
                }
            }
            catch (Exception b)
            {
                consoleWriterMain.DebugLog(b.ToString(), ConfigurationManager.LogType.ERROR);
            }
        }

        private void buttonMasterClientListHelp_Click(object sender, EventArgs e)
        {
            MessageBox.Show(StaticTextLibrary.HelpText.MasterClient, "Master Client Help", MessageBoxButtons.OK, MessageBoxIcon.Question);
        }

        private void buttonRefreshClients_Click(object sender, EventArgs e)
        {
            InputCallback.ProcManager.RefreshClientProcList();

            PopulateClientList();
            PopulateCharacterList();

            config.UpdateStatus($"Found {InputCallback.ProcManager.GameProcList.Length} process(es).", ConfigurationManager.LogType.MESSAGE);
        }

        #region Private Methods - Multiboxing Tab

        private void PopulateClientList()
        {
            listBoxSelectMasterClient.Items.Clear();

            foreach (WoWClient c in InputCallback.ProcManager.GameClientList)
            {
                listBoxSelectMasterClient.Items.Add($"{c.Player.Name} - {c.GameProcess.Id}");
            }
        }

        private void StartStopMultiboxing()
        {
            bool errorOccurred = false;

            if (!isListening)
            {
                if (InputCallback.ProcManager.MasterClient == null) // error checking
                {
                    errorOccurred = true;
                    MessageBox.Show(StaticTextLibrary.ErrorText.MasterClientMain, "Multiboxer", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    input.Subscribe();

                    buttonStartMultiboxing.Text = "Stop Multiboxing";

                    config.UpdateStatus($"Multiboxing started.", ConfigurationManager.LogType.MESSAGE);
                }
            }
            else if (isListening)
            {
                input.Unsubscribe();

                buttonStartMultiboxing.Text = "Start Multiboxing";

                config.UpdateStatus($"Multiboxing stopped.", ConfigurationManager.LogType.MESSAGE);
            }

            if (!errorOccurred)
            {
                isListening = !isListening;
            }
        }
        #endregion Private Methods - Multiboxing Tab

        #endregion MULTIBOXING TAB

        #region IGNORE LIST TAB
        private void buttonSaveIgnoreList_Click(object sender, EventArgs e)
        {
            InputCallback.ProcManager.SetIgnoredKeys(richTextBoxIgnoreList);

            config.SaveToConfig(richTextBoxIgnoreList.Lines);

            config.UpdateStatus($"Saved IgnoreList to config file successfully.", ConfigurationManager.LogType.MESSAGE);
        }

        private void buttonIgnoreListHelp_Click(object sender, EventArgs e)
        {
            MessageBox.Show(StaticTextLibrary.HelpText.IgnoreList, "Ignore List Help", MessageBoxButtons.OK, MessageBoxIcon.Question);
        }

        private void checkBoxEnableIgnoreList_CheckedChanged(object sender, EventArgs e)
        {
            InputCallback.ProcManager.SetIgnoreListEnabled(checkBoxEnableIgnoreList.Checked);

            switch(checkBoxEnableIgnoreList.Checked)
            {
                case true:
                    config.UpdateStatus("IgnoreList enabled.", ConfigurationManager.LogType.MESSAGE);
                    break;

                case false:
                    config.UpdateStatus("IgnoreList disabled.", ConfigurationManager.LogType.MESSAGE);
                    break;
            }
        }

        private void checkBoxBlacklist_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBoxBlacklist.Checked)
            {
                if (checkBoxWhitelist.Checked)
                {
                    checkBoxWhitelist.CheckState = CheckState.Unchecked;
                    config.UpdateStatus("IgnoreList setting changed to blacklist.", ConfigurationManager.LogType.MESSAGE); // needs to be put here to avoid being sent every time it is clicked, even if setting is not actually changing
                }

                InputCallback.ProcManager.SetIgnoreListType(ProcessManager.IgnoreType.BLACKLIST);
            }

            if (!checkBoxBlacklist.Checked && !checkBoxWhitelist.Checked)
            {
                checkBoxBlacklist.CheckState = CheckState.Checked;
            }
        }

        private void checkBoxWhitelist_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBoxWhitelist.Checked)
            {
                if (checkBoxBlacklist.Checked)
                {
                    checkBoxBlacklist.CheckState = CheckState.Unchecked;
                    config.UpdateStatus("IgnoreList setting changed to whitelist.", ConfigurationManager.LogType.MESSAGE); // needs to be put here to avoid being sent every time it is clicked, even if setting is not actually changing
                }

                InputCallback.ProcManager.SetIgnoreListType(ProcessManager.IgnoreType.WHITELIST);
            }

            if (!checkBoxBlacklist.Checked && !checkBoxWhitelist.Checked)
            {
                checkBoxWhitelist.CheckState = CheckState.Checked;
            }
        }
        #endregion IGNORE LIST TAB

        #region MACRO GENERATOR TAB

        private void listBoxMacroGenCharacterSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (listBoxMacroGenCharacterSelect.SelectedItem != null) // avoid unecessary exceptions
                {
                    if (InputCallback.ProcManager.MasterClient != null)
                    {
                        WoWClient selectedClient = new WoWClient();

                        foreach (WoWClient c in InputCallback.ProcManager.GameClientList)
                        {
                            if (listBoxMacroGenCharacterSelect.SelectedItem.ToString() == c.Player.Name)
                            {
                                selectedClient = c;
                                break;
                            }
                        }

                        // did we select the master?
                        if (listBoxMacroGenCharacterSelect.SelectedItem.ToString().Equals(InputCallback.ProcManager.MasterClient.Player.Name))
                        {
                            PopulateMacroList(true, selectedClient.Player.Class); // new method; pop macro list for master ('true')
                        }
                        else
                        {
                            PopulateMacroList(false, selectedClient.Player.Class); // new method; pop macro list for children ('false')
                        }
                    }
                    else
                    {
                        MessageBox.Show(StaticTextLibrary.ErrorText.MasterClientMacro, "Macro Generator", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                }
            }
            catch (Exception b)
            {
                consoleWriterMain.DebugLog(b.ToString(), ConfigurationManager.LogType.ERROR);
            }
        }

        private void listBoxGeneratedMacros_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (listBoxGeneratedMacros.SelectedItem != null) // Avoid unecessary exceptions
                {
                    if (listBoxMacroGenCharacterSelect.SelectedItem.ToString().Equals(InputCallback.ProcManager.MasterClient.Player.Name)) // did we select the master?
                    {
                        PopulateMacroData(listBoxGeneratedMacros.SelectedItem.ToString(), _masterMacroList[listBoxGeneratedMacros.SelectedItem.ToString()]); // new method; pop macro data by selected item (key) and content value of selected item (key)
                    }
                    else
                    {
                        PopulateMacroData(listBoxGeneratedMacros.SelectedItem.ToString(), _childMacroList[listBoxGeneratedMacros.SelectedItem.ToString()]); // new method; pop macro data by selected item (key) and content value of selected item (key)
                    }
                }
            }
            catch (Exception b)
            {
                consoleWriterMain.DebugLog(b.ToString(), ConfigurationManager.LogType.ERROR);
            }
        }

        private void buttonCopyMacroName_Click(object sender, EventArgs e)
        {
            if (textBoxMacroName.Text != string.Empty)
            {
                Clipboard.SetText(textBoxMacroName.Text);

                MessageBox.Show("Copied to clipboard!", "Macro Generator", MessageBoxButtons.OK);
            }
        }

        private void buttonMacroGenHelp_Click(object sender, EventArgs e)
        {
            MessageBox.Show(StaticTextLibrary.HelpText.MacroGenerator, "Macro Generator Help", MessageBoxButtons.OK, MessageBoxIcon.Question);
        }

        private void buttonCopyMacroContent_Click(object sender, EventArgs e)
        {
            if (richTextBoxMacroContent.Text != string.Empty)
            {
                Clipboard.SetText(richTextBoxMacroContent.Text);

                MessageBox.Show("Copied to clipboard!", "Macro Generator", MessageBoxButtons.OK);
            }
        }

        #region Private Methods - Macro Generator Tab

        private void PopulateCharacterList()
        {
            listBoxMacroGenCharacterSelect.Items.Clear();

            foreach (WoWClient c in InputCallback.ProcManager.GameClientList)
            {
                listBoxMacroGenCharacterSelect.Items.Add(c.Player.Name);
            }
        }

        private void PopulateMacroList(bool isMaster, Enums.Game.PlayerClass playerClass)
        {
            listBoxGeneratedMacros.Items.Clear();

            if (isMaster)
            {
                _masterMacroList.Clear();

                string[] childNames = new string[InputCallback.ProcManager.GameClientList.Length - 1]; // it is the size of all clients minus master

                int i = 0;

                foreach (WoWClient c in InputCallback.ProcManager.GameClientList)
                {
                    if (c.GameProcess.Id != InputCallback.ProcManager.MasterClient.GameProcess.Id)
                    {
                        childNames[i] = c.Player.Name;
                        i++;
                    }
                }

                _masterMacroList = MacroGenerator.GenerateMasterMacros(childNames);

                foreach (string s in _masterMacroList.Keys)
                {
                    listBoxGeneratedMacros.Items.Add(s);
                }
            }
            else
            {
                _childMacroList.Clear();

                string masterName = InputCallback.ProcManager.MasterClient.Player.Name;

                _childMacroList = MacroGenerator.GenerateChildMacros(masterName, playerClass);

                foreach (string s in _childMacroList.Keys)
                {
                    listBoxGeneratedMacros.Items.Add(s);
                }
            }
        }

        private void PopulateMacroData(string macroName, string macroContent)
        {
            textBoxMacroName.Text = macroName;
            richTextBoxMacroContent.Text = macroContent;
        }

        #endregion Private Methods - Macro Generator Tab

        #endregion MACRO GENERATOR TAB
    }
}
