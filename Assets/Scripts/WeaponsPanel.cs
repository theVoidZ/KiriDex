using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WeaponsPanel : MonoBehaviour
{
    private Transform[,] weaponFragments = new Transform[3,3];

    private bool[,] gliderPreset =
    {
        {false, true, false}, {true, false, false}, {true, true, true}
    };

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SetAt(int x, int y)
    {
        // in Vector coordinates
        x +=1;
        y += 1;
        
        GameObject unit = FindObjectOfType<SpawnBlock>().weaponUnit;
        GameObject glider = FindObjectOfType<SpawnBlock>().glider;
        
        if (UnitAvailable(x, y))
        {
            // Debug.Log("x,y: " + x + "," + y);
            weaponFragments[x, y] = Instantiate(unit ,glider.transform.position, Quaternion.identity).transform;
            weaponFragments[x, y].position += new Vector3(x-1,y-1,0);
            weaponFragments[x, y].parent = glider.transform;
            
            CheckUnitCompleted();
        }
    }

    public bool UnitAvailable(int x, int y)
    {
        
        if (weaponFragments[x, y] == null && gliderPreset[x,y] )
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public void CheckUnitCompleted()
    {
        SpawnBlock Spawner = FindObjectOfType<SpawnBlock>();

        for (int i = 0; i <= 2; i++)
        {
            for (int j = 0; j <= 2; j++)
            {
                if ( gliderPreset[i,j] != ( weaponFragments[i,j] !=null) )
                {
                    return;
                }
            } 
        }

        if (!Spawner.GetGameOver())
        {
            Spawner.SetGameOver();
            LTDescr ltDescr = LeanTween.move(Spawner.glider, new Vector3(-6, 15, 0), 3f).setEase(LeanTweenType.easeInExpo);
            if (ltDescr != null)
            {
                ltDescr.setOnComplete(NextScene);
            }
        }

    }

    public void NextScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
}
