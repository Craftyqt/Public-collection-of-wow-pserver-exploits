using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Gma.System.MouseKeyHook;

namespace Multiboxer
{
    class InputCallback
    {
        /* InputCallback
         * Handles subscribe/unsubscribe from global keyboard/mouse hooks and callback methods.
         * Also holds the main ProcessManager instance, which is accessible only through InputCallback */

        public static ProcessManager ProcManager;

        private IKeyboardMouseEvents m_GlobalHook;

        public InputCallback()
        {
            ProcManager = new ProcessManager();
        }

        public void Subscribe()
        {
            m_GlobalHook = Hook.GlobalEvents();

            m_GlobalHook.KeyDown += InputCallback_OnKeyDown;
            m_GlobalHook.KeyUp += InputCallback_OnKeyUp;
            //m_GlobalHook.MouseDown += Hook_OnMouseDown;
            //m_GlobalHook.MouseUp += Hook_OnMouseUp;
        }

        private void InputCallback_OnKeyDown(object sender, KeyEventArgs e) // TODO: add error handling to input callbacks
        {
            ProcManager.RefreshClientProcList();

            if (ProcManager.IgnoreListEnabled)
            {
                if (ProcManager.IgnoreListType == ProcessManager.IgnoreType.BLACKLIST) // BLACKLIST
                {
                    bool keyIsBlacklisted = false;

                    int i = 0;

                    if (ProcManager.IgnoredKeys != null)
                    {
                        foreach (Keys key in ProcManager.IgnoredKeys)
                        {
                            if (e.KeyCode.Equals(ProcManager.IgnoredKeys[i]))
                            {
                                keyIsBlacklisted = true;
                            }

                            i++;
                        }
                    }

                    if (keyIsBlacklisted)
                    {
                        return;
                    }
                    else
                    {
                        foreach (Process p in ProcManager.GameProcList)
                        {
                            if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                            {
                                if (e.Control) // Press control
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ControlKey);
                                }

                                // Replace bad values
                                if (e.KeyValue == (int)Keys.LShiftKey) // Replace LShiftKey with ShiftKey
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ShiftKey);
                                }
                                else if (e.KeyValue == (int)Keys.LControlKey)
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ControlKey);
                                }
                                else
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, (Keys)e.KeyValue);
                                }
                            }
                        }
                    }
                }
                else if (ProcManager.IgnoreListType == ProcessManager.IgnoreType.WHITELIST)
                {
                    bool keyIsWhitelisted = false;

                    int i = 0;
                    
                    if (ProcManager.IgnoredKeys != null)
                    {
                        foreach (Keys key in ProcManager.IgnoredKeys)
                        {
                            if (e.KeyCode.Equals(ProcManager.IgnoredKeys[i]))
                            {
                                keyIsWhitelisted = true;
                            }

                            i++;
                        }
                    }

                    if (keyIsWhitelisted) // essentially just do the opposite of what is done in the blacklist
                    {
                        foreach (Process p in ProcManager.GameProcList)
                        {
                            if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                            {
                                if (e.Control) // Press control
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ControlKey);
                                }

                                // Replace bad values
                                if (e.KeyValue == (int)Keys.LShiftKey) // Replace LShiftKey with ShiftKey
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ShiftKey);
                                }
                                else if (e.KeyValue == (int)Keys.LControlKey)
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ControlKey);
                                }
                                else
                                {
                                    WindowUtil.PostKeyDown(p.MainWindowHandle, (Keys)e.KeyValue);
                                }
                            }
                        }
                    }
                    else
                    {
                        return;
                    }
                }
            }
            else // Ignore list disabled
            {
                foreach (Process p in ProcManager.GameProcList)
                {
                    if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                    {
                        if (e.Control) // Press control
                        {
                            WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ControlKey);
                        }

                        // Replace bad values
                        if (e.KeyValue == (int)Keys.LShiftKey) // Replace LShiftKey with ShiftKey
                        {
                            WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ShiftKey);
                        }
                        else if (e.KeyValue == (int)Keys.LControlKey)
                        {
                            WindowUtil.PostKeyDown(p.MainWindowHandle, Keys.ControlKey);
                        }
                        else
                        {
                            WindowUtil.PostKeyDown(p.MainWindowHandle, (Keys)e.KeyValue);
                        }
                    }
                }
            }
        }

        private void InputCallback_OnKeyUp(object sender, KeyEventArgs e)
        {
            ProcManager.RefreshClientProcList();

            if (ProcManager.IgnoreListEnabled)
            {
                if (ProcManager.IgnoreListType == ProcessManager.IgnoreType.BLACKLIST) // BLACKLIST
                {
                    bool keyIsBlacklisted = false;

                    int i = 0;

                    if (ProcManager.IgnoredKeys != null)
                    {
                        foreach (Keys key in ProcManager.IgnoredKeys)
                        {
                            if (e.KeyCode.Equals(ProcManager.IgnoredKeys[i]))
                            {
                                keyIsBlacklisted = true;
                            }

                            i++;
                        }
                    }

                    if (keyIsBlacklisted)
                    {
                        return;
                    }
                    else
                    {
                        foreach (Process p in ProcManager.GameProcList)
                        {
                            if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                            {
                                if (e.Control) // Press control
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ControlKey);
                                }

                                // Replace bad values
                                if (e.KeyValue == (int)Keys.LShiftKey) // Replace LShiftKey with ShiftKey
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ShiftKey);
                                }
                                else if (e.KeyValue == (int)Keys.LControlKey)
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ControlKey);
                                }
                                else
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, (Keys)e.KeyValue); // Converting the KeyValue from int to Keys enum (the int in KeyValue is the identifier for the Key in the Keys enum..)
                                }
                            }
                        }
                    }
                }
                else if (ProcManager.IgnoreListType == ProcessManager.IgnoreType.WHITELIST)
                {
                    bool keyIsWhitelisted = false;

                    int i = 0;

                    if (ProcManager.IgnoredKeys != null)
                    {
                        foreach (Keys key in ProcManager.IgnoredKeys)
                        {
                            if (e.KeyCode.Equals(ProcManager.IgnoredKeys[i]))
                            {
                                keyIsWhitelisted = true;
                            }

                            i++;
                        }
                    }

                    if (keyIsWhitelisted)
                    {
                        foreach (Process p in ProcManager.GameProcList)
                        {
                            if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                            {
                                if (e.Control) // Press control
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ControlKey);
                                }

                                // Replace bad values
                                if (e.KeyValue == (int)Keys.LShiftKey) // Replace LShiftKey with ShiftKey
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ShiftKey);
                                }
                                else if (e.KeyValue == (int)Keys.LControlKey)
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ControlKey);
                                }
                                else
                                {
                                    WindowUtil.PostKeyUp(p.MainWindowHandle, (Keys)e.KeyValue);
                                }
                            }
                        }
                    }
                    else // do opposite of blacklist; return if key is not whitelisted
                    {
                        return;
                    }
                }
            }
            else // ignore list disabled
            {
                foreach (Process p in ProcManager.GameProcList)
                {
                    if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                    {
                        if (e.Control) // Press control
                        {
                            WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ControlKey);
                        }

                        // Replace bad values
                        if (e.KeyValue == (int)Keys.LShiftKey) // Replace LShiftKey with ShiftKey
                        {
                            WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ShiftKey);
                        }
                        else if (e.KeyValue == (int)Keys.LControlKey)
                        {
                            WindowUtil.PostKeyUp(p.MainWindowHandle, Keys.ControlKey);
                        }
                        else
                        {
                            WindowUtil.PostKeyUp(p.MainWindowHandle, (Keys)e.KeyValue);
                        }
                    }
                }
            }
        }

        private void InputCallback_OnMouseDown(object sender, MouseEventArgs e)
        {
            ProcManager.RefreshClientProcList();

            foreach (Process p in ProcManager.GameProcList)
            {
                if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id))
                {
                    if (e.Button == MouseButtons.Left)
                    {
                        WindowUtil.PostMouseLeftDown(p.MainWindowHandle);
                    }
                    else if (e.Button == MouseButtons.Right)
                    {
                        WindowUtil.PostMouseRightDown(p.MainWindowHandle);
                    }
                }
            }
        }

        private void InputCallback_OnMouseUp(object sender, MouseEventArgs e)
        {
            ProcManager.RefreshClientProcList();

            foreach (Process p in ProcManager.GameProcList)
            {
                if (!p.Id.Equals(ProcManager.MasterClient.GameProcess.Id)) // .Equals() compares the contents, == compares the reference
                {
                    if (e.Button == MouseButtons.Left)
                    {
                        WindowUtil.PostMouseLeftUp(p.MainWindowHandle);
                    }
                    else if (e.Button == MouseButtons.Right)
                    {
                        WindowUtil.PostMouseRightUp(p.MainWindowHandle);
                    }
                }
            }
        }

        public void Unsubscribe()
        {
            m_GlobalHook.KeyDown -= InputCallback_OnKeyDown;
            m_GlobalHook.KeyUp -= InputCallback_OnKeyUp;
            //m_GlobalHook.MouseDown -= Hook_OnMouseDown;
            //m_GlobalHook.MouseUp -= Hook_OnMouseUp;

            m_GlobalHook.Dispose();
        }
    }
}
