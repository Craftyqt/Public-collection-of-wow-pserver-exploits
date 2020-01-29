using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Windows.Forms;

namespace Multiboxer
{
    class ProcessManager
    {
        /* ProcessManager
         * Handles most all functions having to do with process manipulation. 
         * Keeps track of master client, client list, key ignores etc.*/

        // Fields

        private readonly string _gameProcessNamePartial = "WoW";

        private ConfigurationManager.ConsoleWriter consoleWriter;

        // Properties

        public WoWClient MasterClient { get; private set; }
        public WoWClient[] GameClientList { get; private set; }
        public Process[] GameProcList { get; private set; }
        public Keys[] IgnoredKeys { get; private set; }
        public IgnoreType IgnoreListType { get; private set; }
        public bool IgnoreListEnabled { get; private set; }

        public enum IgnoreType
        {
            BLACKLIST,
            WHITELIST
        }

        // Constructor
        public ProcessManager()
        {
            RefreshClientProcList();

            // default settings
            IgnoreListEnabled = true;
            IgnoreListType = IgnoreType.BLACKLIST;
        }

        // Mutators (not simple mutators, more of methods that select the value)

        public void SetConsoleWriter(ConfigurationManager.ConsoleWriter writer)
        {
            consoleWriter = writer;
        }

        public void SetMasterClient(int procId) // using this to test what memory i'm reading, ie. how to read memory
        {
            Process master = Process.GetProcessById(procId);

            MasterClient = new WoWClient(master.Id);

            consoleWriter.Clear();

            consoleWriter.DebugLog($"Set master client to {MasterClient.Player.Name} - {procId}", ConfigurationManager.LogType.MESSAGE);
            consoleWriter.DebugLog($"Game version - {MasterClient.Player.GameVersion}", ConfigurationManager.LogType.MESSAGE);
            consoleWriter.DebugLog($"Realm name - {MasterClient.Player.RealmName}", ConfigurationManager.LogType.MESSAGE);
            consoleWriter.DebugLog($"Class - {MasterClient.Player.ClassName}", ConfigurationManager.LogType.MESSAGE);
        }

        public void SetIgnoredKeys(RichTextBox rtb)
        {
            if (rtb.Lines.Length > 0) // avoiding exceptions
            {
                if (!rtb.Lines[rtb.Lines.Length - 1].ToString().Equals("")) // avoiding exceptions
                {
                    IgnoredKeys = new Keys[rtb.Lines.Length];

                    int j = 0;

                    foreach (string line in rtb.Lines)
                    {
                        try
                        {
                            string formatLine = line.Replace("\n", "");

                            IgnoredKeys[j] = (Keys)Enum.Parse(typeof(Keys), formatLine, false);
                            j++;
                        }
                        catch (Exception b) // TODO add error handling/logging
                        {
                            consoleWriter.DebugLog(b.ToString(), ConfigurationManager.LogType.ERROR);
                            break;
                        }
                    }

                    consoleWriter.DebugLog("Saved IgnoreList:", ConfigurationManager.LogType.CONFIG);

                    for (int i = 0; i < IgnoredKeys.Length; i++)
                    {
                        consoleWriter.DebugLog(IgnoredKeys[i].ToString(), ConfigurationManager.LogType.CONFIG);
                    }
                }
            }
            else
            {
                IgnoredKeys = new Keys[0];
            }
        }

        public void SetIgnoreListType(IgnoreType type) => IgnoreListType = type;

        public void SetIgnoreListEnabled(bool value) => IgnoreListEnabled = value;

        // Public methods

        public void RefreshClientProcList()
        {
            try
            {
                Process[] procs = Process.GetProcesses();

                int i = 0;

                foreach (Process p in procs)
                {
                    if (p.ProcessName.Contains(_gameProcessNamePartial))
                    {
                        i++;
                    }
                }

                WoWClient[] tempClientList = new WoWClient[i];

                int j = 0;

                foreach (Process p in procs)
                {
                    if (j >= i)
                    {
                        break;
                    }

                    if (p.ProcessName.Contains(_gameProcessNamePartial))
                    {
                        tempClientList[j] = new WoWClient(p.Id);
                        j++;
                    }
                }

                Process[] tempProcList = new Process[tempClientList.Length];

                int y = 0;

                foreach (WoWClient c in tempClientList)
                {
                    if (y >= j)
                    {
                        break;
                    }

                    tempProcList[y] = tempClientList[y].GameProcess;
                    y++;
                }

                GameProcList = tempProcList;
                GameClientList = tempClientList;
            }
            catch (Exception b)
            {
                consoleWriter.DebugLog(b.ToString(), ConfigurationManager.LogType.ERROR);
            }
        }
    }
}
