using System.Linq;

namespace Nerdery.CSharpCodeStyle.Tests
{
    /// <summary>
    /// This is a test for the things.
    /// </summary>
    public class DocumentationTests
    {
        /// <summary>
        /// Gets or sets This here documentation for Variable 3.
        /// </summary>
        public string Variable3 { get; set; }

        /// <summary>
        /// Gets or sets This here documentation for Variable 4.
        /// </summary>
        public string Variable4 { get; set; }

        /// <summary>
        /// Gets or sets this here documentation for Variable 5.
        /// </summary>
        internal string Variable5 { get; set; }

        /// <summary>
        /// Gets or sets this here documentation for Variable 6.
        /// </summary>
        internal string Variable6 { get; set; }

        protected string Variable7 { get; set; }

        protected string Variable8 { get; set; }

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