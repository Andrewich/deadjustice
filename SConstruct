env = Environment()

if ARGUMENTS.get('VERBOSE') != '1':
    '''scons VERBOSE=1'''
    env['CCCOMSTR'] = "Compiling $TARGET"
    env['CXXCOMSTR'] = "Compiling $TARGET"    
    env['LINKCOMSTR'] = "Linking $TARGET"

if env['PLATFORM'] == 'win32':
    env.AppendUnique(CXXFLAGS = "/std:c++14")

# Add the Debug Flags if debug=1 is specified on the command line, this tends to be compiler specific
if int(ARGUMENTS.get('debug', 0)):
    if env['PLATFORM'] == 'win32':
        env.Append(CPPDEFINES = ['NDEBUG'])
    variant = 'Release'
else:
    if env['PLATFORM'] == 'win32':
        env.Append(CPPDEFINES = ['DEBUG', '_DEBUG'])
        env.Append(CCFLAGS='/MDd')
        env.Append(CCFLAGS=Split('/Zi /Fd${TARGET}.pdb'))
        env.Append(LINKFLAGS = ['/DEBUG'])
    variant = 'Debug'

print("Building: " + variant)

Export('env')

env.SConscript('src/SConscript', variant_dir='build/$PLATFORM')

if Execute(Mkdir('bin')):
    # A problem occurred while making the directory.
    Exit(1)

if Execute(Mkdir('lib')):
    # A problem occurred while making the directory.
    Exit(1)
    
#env.Install('bin', main)
