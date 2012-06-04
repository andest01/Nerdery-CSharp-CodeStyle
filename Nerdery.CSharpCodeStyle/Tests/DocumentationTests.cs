using System.Linq;

namespace Nerdery.CSharpCodeStyle.Tests
{
    /// <summary>
    /// This is a test for the things.
    /// </summary>
    public class DocumentationTests
    {
        public string Variable3 { get; set; }

        public string Variable4 { get; set; }

        private string Variable1 { get; set; }

        private string Variable2 { get; set; }

        /// <summary>
        /// This is a public Method1.
        /// </summary>
        public void Method1()
        {
        }

        /// <summary>
        /// Documenting the method things
        /// </summary>
        /// <param name="x">The x paramater</param>
        /// <param name="y">The y paramater</param>
        public void Method2(string x, int y)
        {
        }

        /// <summary>
        /// This is Method3.
        /// </summary>
        public void Method3()
        {
        }
    }
}