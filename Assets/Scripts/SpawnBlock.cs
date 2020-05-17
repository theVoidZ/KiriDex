using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SpawnBlock : MonoBehaviour
{
    public GameObject[] Blocks;
    public GameObject PlaceHolder;
    public GameObject dropItem;
    public GameObject weaponUnit;
    public GameObject glider;
    public Text generationCount;
    public Text simulationCount;
    public Text triggerSkip;

    private bool simulationLocked = false;

    private bool gameOver = false;


    public AudioManager audioManager;
    
    // Start is called before the first frame update
    void Start()
    {
        audioManager = GetComponent<AudioManager>();
        NewBlock();
    }

    // Update is called once per frame
    void Update()
    {
        if (simulationLocked && !gameOver)
        {
            if (Input.GetKeyDown(KeyCode.G) )
            {
                Debug.Log("G PRESSED");
                // solve the level
                WeaponsPanel weaponPanel = FindObjectOfType<WeaponsPanel>();
                for (int i = -1; i <= 1; i++)
                {
                    for (int j = -1; j <= 1; j++)
                    {
                        weaponPanel.SetAt(i, j);
                    }                    
                }

                weaponPanel.CheckUnitCompleted();
            }
        }   
    }

    public void SetGameOver()
    {
        gameOver = true;
    }

    public bool GetGameOver()
    {
        return gameOver;
    }
    
    public void NewBlock()
    {
        if (gameOver)
        {
            return;
        }
        GameObject block = Instantiate(Blocks[Random.Range(0, Blocks.Length)], transform.position, Quaternion.identity);
        if (!ValidSpawnLocation(block))
        {
            triggerSkip.gameObject.SetActive(true);
            simulationLocked = true;
            StartCoroutine(NextGeneration());
            return;
        }
        
        // spawn a random drop
        int nth_block = Mathf.RoundToInt( Random.Range( 0, block.transform.childCount-1) );
        int x = Mathf.RoundToInt(Random.Range(0, 2)) - 1;
        int y = Mathf.RoundToInt(Random.Range(0, 2)) - 1;
        
        GameObject go_item = Instantiate(dropItem, block.transform.GetChild(nth_block));
        go_item.transform.localPosition = new Vector3( go_item.transform.localScale.x * x, go_item.transform.localScale.y * y, 0 );

        block.transform.GetChild(nth_block).gameObject.AddComponent<TileItemDrops>().SetLocation(x, y);
        
    }
    
    bool ValidSpawnLocation(GameObject b)
    {
        foreach (Transform child in b.transform)
        {
            int roundedX = Mathf.RoundToInt(child.transform.position.x);
            int roundedY = Mathf.RoundToInt(child.transform.position.y);

            if (roundedX < 0 || roundedX >= TetrisBlock.width || roundedY < 0 || roundedY >= TetrisBlock.height)
            {
                Destroy(b);
                return false;
            }

            if (TetrisBlock.grid[roundedX, roundedY] != null )
            {
                Destroy(b);
                return false;
            }
        }

        return true;
    }

    IEnumerator NextGeneration(){
        yield return new WaitForSeconds(0.15f);
        TetrisBlock.ApplyConway();
        NewBlock();
    }
    
}

