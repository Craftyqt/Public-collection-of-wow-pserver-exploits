using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Multiboxer
{
    internal static class StaticTextLibrary
    {
        /* GUIStringLibrary:
         * This class simply contains (generally long) strings that are used in the GUI. 
         * They are stored in a separate class for code readability. */

        internal static class HelpText
        {
            internal static string IgnoreList = "The Ignore List can be useful in specifying which keystrokes you do not want the Multiboxer to send to other clients. For example, if you chose to ignore the key 'D', whenever the key D is pressed, it will not be sent to the child clients." +
            "\n\nSyntax: To specify a key to ignore, you must enter the name that corresponds with the .NET Keys enum identifier for that key. For a full list of Keys, please visit https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=netframework-4.8." +
            "\n\nExample: If you wanted to ignore the key '7' on the keyboard, you would enter 'D7' (the Keys enum identifer for that key). Each key that you would like to ignore should be placed on a new line with ABSOLUTELY NO whitespace! Good luck!";

            internal static string MasterClient = "The Master Client is the client in which you are actively using (ie. playing on). The master client must be specified before starting the Multiboxer in order to prevent Keystrokes from being sent to it.";

            internal static string MacroGenerator = "The Macro Generator generates multiboxing macros for you, based on the roles of the characters (follower/master?), the characters classes and the characters names.\n\nIn order to use the Macro Generator, " +
            "make sure the client list is current (refresh it,) select a Master Client (the client in which you will be playing on), and simply select a character to see what macros he/she has available.\n\nWhen you select a macro, simply copy the content " +
            "(and optionally, the title), open the Macros window in-game, create a new macro and paste the content/title into it. If using class-specific macros, it is recommended to make the macro icon match the in-game ability icon.\n\n" +
            "If the macro explicitly states it, bind certain macros to the same key on all characters for smoother gameplay (for example, the Invite/AcceptGroup macros.) For other macros, bind them to any key you like and the macro will be used when you press the bound key on any window. Enjoy!";
        }

        internal static class ErrorText
        {
            internal static string MasterClientMain = "Please select the Master Client (the client in which you are going to be playing on) before starting the Multiboxer.";

            internal static string MasterClientMacro = "Please select the Master Client (the client in which you are going to be playing on) in the main Multiboxing tab before trying to generate macros.";
        }
    }
}
